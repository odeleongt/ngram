# Load used packages
library(package = ff)
library(package = data.table)
library(package = tidyr)
library(package = dplyr)


# Load data
ffload("./data/nall_ff", rootpath = "./data/")
load("./data/index.RData")

cat("\n\nRead the data\n\n")

# Setup lookup options
N <- nrow(nall_ff) # Dataset size
n <- 1e6 # Chunk size


# Default prediction
top <- index$word[index$level %in% 1:3]

# Prediction function
get_prediction <- function(tokens, output){
  
  #*---------------------------------------------------------------------------*
  # Prepare tokens
  #*---------------------------------------------------------------------------*
  
  # Use character vector
  tokens <- unlist(tokens)
  cat("Got tokens:\n", tokens, "\n\n", sep=" ")
  
  # Index them
  tokens <- as.ushort(na.omit(index[tokens, level]))
  
  # Ensure proper length
  if(length(tokens) < 3){
    # Fill up with "no-value" 16657
    tokens <- as.ushort(c(rep(16657, 3-length(tokens)), tokens))
  } else {
    # Select last tokens
    tokens <- tail(x = tokens, n = 3)
  }
  
  
  #*---------------------------------------------------------------------------*
  # Handle empty input
  #*---------------------------------------------------------------------------*
  if(all(tokens == 16657)){
    return(top)
  }
  
  
  #*---------------------------------------------------------------------------*
  # Lookup with bit indexing
  #*---------------------------------------------------------------------------*
  
  # Empty indexes
  fn3 <- bit(N)
  fn2 <- bit(N)
  fn1 <- bit(N)
  
  # Index
  for (i in chunk(1,N,n)){
    fn3[i] <- (nall_ff$n3[i] == tokens[1]) | (nall_ff$params[i] %in% as.quad(c(3, 2)))
    fn2[i] <- (nall_ff$n2[i] == tokens[2]) | (nall_ff$params[i] == as.quad(2))
    fn1[i] <- nall_ff$n1[i] == tokens[3]
    }
  biti <- fn3 & fn2 & fn1
  
  # Response
  if(!any(biti)){
    return(top)
  }
  
  found <- data.table(
    as.ram(nall_ff[biti, c("n0", "n3", "n2", "n1", "N", "params")]))
  
  #*---------------------------------------------------------------------------*
  # Process predictions
  #*---------------------------------------------------------------------------*
  
  # Get top predictions
  setkey(found, n3, n2, n1, N)
  top_predictions <- unique(found[, tail(.SD, 3), by='n3,n2,n1'][, n0])
  
  setkey(found, n0)
  top_predictions <- found[list(top_predictions)]
  
  setkey(top_predictions, n3, n2, n1)
  setkey(found, n3, n2, n1, N)
  
  # Get denominator for likelihood
  denominators <- found[top_predictions,
                        list(all=sum(N)),
                        by='params,n3,n2,n1',
                        allow.cartesian = TRUE]
  
  
  # Get likelihoods
  found <- top_predictions %>%
    left_join(denominators) %>%
    mutate(likely = (N-1) / (all + 1)) %>%
    select(n0, params, likely) %>%
    mutate(params = factor(paste0(params, "-gram"),
                           levels = paste0(2:4, "-gram"))) %>%
    spread(key = params, value = likely, fill = 0, drop = FALSE) %>%
    mutate(likelihood = `2-gram` + `3-gram` + `4-gram`) %>%
    arrange(desc(likelihood)) %>% 
    select(n0, everything()) %>%
    data.table
  
  setkey(found, "n0")
  
  
  # Translate prediction
  found <- xedni[found][order(c(-likelihood))]
  
  
  # Show details on the app
  if(!is.null(output)){
    observe({
      output$predictions <-
        renderTable({
          found %>%
            top_n(3, likelihood) %>%
            rename(overall = likelihood) %>%
            select(-level)
        },
        digits = 6)
    })
  }
  
  # Return top 3 predictions
  return(found[1:3, word])
}
