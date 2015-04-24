# Load used packages
library(package = ff)
library(package = data.table)

# Load data
ffload("./data/n2_ff", rootpath = "./data")
load("./data/index.RData")

# Setup lookup options
N <- nrow(n2_ff) # Dataset size
n <- 1e6 # Chunk size


# Test tokens
tokens <- c("this", "is", "a")


# Prediction function
get_prediction <- function(tokens){
  
  #*---------------------------------------------------------------------------*
  # Prepare tokens
  #*---------------------------------------------------------------------------*
  
  # Use character vector
  tokens <- unlist(tokens)

  # Select last tokens
  tokens <- tail(x = tokens, n = 1)
  
  # Index them
  tokens <- index[tokens, level]
  
  
  
  
  #*---------------------------------------------------------------------------*
  # Lookup with bit indexing
  #*---------------------------------------------------------------------------*
  
  # Empty indexes
  fn1 <- bit(N)
  
  # Index
  for (i in chunk(1,N,n)){
    fn1[i] <- n2_ff$n1[i] == tokens[1]
  }
  biti <- fn1
  
  # Response
  if(any(biti)){
    found <- data.table(as.ram(n2_ff[biti, c("n0", "N")]))
  } else {
    found <- data.table(n0=integer(0), N = integer(0))
  }
  
  
  #*---------------------------------------------------------------------------*
  # Process predictions
  #*---------------------------------------------------------------------------*
  
  # Translate prediction
  found <- xedni[found][order(-N)]
  
  # Return top 3 predictions
  return(found[1:3, word])
}
