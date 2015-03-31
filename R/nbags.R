#' Get co-occuring words
#' 
#' Used to test for word co occuresnce regardless of order.

#' @seealso \code{\link{combn}}, \code{\link{assign}}
#' @param tokens An object which can be coerced to \code{character} and contains
#'   vectors of adjacent tokens (\emph{e.g.} a list of tokenized sentences).
#' @param n The number of tokens per bag.
#' @param ref A vector of words to include in the bags, or FALSE to include everything.
#' @export
#' @examples
#' # Test ngram generation
# corpus <- c("This is a test sentence", "This is another test")
# tokens <- strsplit(tolower(corpus), split = " ")
# nbags(tokens, n = 2L, ref = c("this", "test", "sentence", "another"))
# nbags(tokens, n = 4L, ref = c("this", "test", "sentence", "another"))
#' @importFrom data.table data.table setnames
#' @importFrom dplyr lag.default
nbags <- function(tokens, n = 3L, ref=FALSE){
  # Only use tokens listed in `ref`
  if(ref[1]!=FALSE) tokens <- lapply(tokens, function(token) token[token %in% ref])
  
  # Only use token groups with enough elements
  tokens <- tokens[sapply(tokens, length)>=n]
  
  # If no token groups apply, return null data.table
  if(!length(tokens)){
    warning("None of the token groups contained at least ", n, " tokens.")
    return(data.table:::null.data.table())
  } else { # Process tokens into n-bags
    bags <- lapply(X = tokens, FUN = function(x) combn(x, m = n, simplify = FALSE))
    
    # Set default column names, rearrange data and aggregate into a data.table
    columns <- paste(paste0("V", seq(1,n)), collapse = ",")
    bags <- data.table(matrix(unlist(bags), ncol = n, byrow=TRUE))[, .N, by=columns]
    
    # Rename columns and return
    tknames <- paste0("t", seq(1, n))
    setnames(bags, c(tknames, "N"))
    return(bags)
  }
}
