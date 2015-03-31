#' Build n-grams from tokens
#' 
#' n-grams will usually be sets of n tokens which are adjacent to each other in
#' a corpus. The adjacency will be limited to some smaller set or semantic unit
#' (\emph(e.g.) a sentence) and tokens from different sets should not be
#' considered adjacent. An efficient way to store sets of tokens in R is a
#' \code{list} (\emph{i.e.} the corpus) composed of \code{character} vectors
#' (\emph{i.e.} the sets) containing the tokens as the vector elements.
#' 
#' n-grams can be obtained by binding the set of tokens to an equivalent but
#' lagged set, and discarding the incomplete n-element groups. Subsetting each
#' set to get variable-length n-grams would be very inefficient so a vector
#' containing all the tokens is used instead, padding each set with \code{NA}s
#' first to avoid a set into the next one.
#' 
#' @seealso \code{\link{assign}}
#' @param tokens An object which can be coerced to \code{character} and contains
#'   vectors of adjacent tokens (\emph{e.g.} a list of tokenized sentences).
#' @param maxn The maximum number of grams to prepare from the tokens.
#' @param tag A lenght one character to append to the name of the generated
#'   data.tables.
#' @param where Environment in which to assign each generated n-gram data.table.
#'   By default assigns to the global environment, see \code{assign} for options.
#' @export
#' @examples
#' # Test ngram generation
#' corpus <- c("This is a test sentence", "This is another test")
#' tokens <- strsplit(corpus, split = " ")
#' ngrams(tokens)
#' @importFrom data.table data.table setnames
#' @importFrom dplyr lag.default
ngrams <- function(tokens, maxn = 3L, tag = "gram", where = search()[1]){
  # Set of n-grams to prepare
  ns <- paste0("n", seq(0, maxn-1))
  
  # Get individual tokens into a data.table as the stems
  # NAs are used to align the unigram column to efficiently bind next n-1 tokens
  tokens <- data.table(stem = unlist(lapply(tokens, c, rep(NA, maxn-1))))
  tokens <- tokens[stem != ""]
  setnames(tokens, "stem", ns[1])
  
  # Bind lagged tokens to stem.
  # Each iteration binds the previous word to the last n words.
  for(previous in seq(2, length(ns))){
    tokens <- tokens[, ns[previous]:= lag(get(ns[previous-1]), n = 1)]
  }
  
  # Remove NA stems used for alignment
  tokens <- tokens[!is.na(get(ns[1]))]
  
  # Fake count for [individual] tokens
  tokens[, N := 1]
  
  # Create specific-gram data.tables
  for(gram in seq(length(ns), 1)){
    # Sum group instances
    tokens <- tokens[, list(N = sum(N)),
                       by=eval(paste(ns[seq(gram, 1)], collapse = ","))]
    
    # Set keys for fast searching
    setkeyv(tokens, cols = ns[seq(gram, 1)])
    
    # Assign the object to the specified environment
    assign(x = paste0("n", gram, "_", tag),
           value = tokens[complete.cases(tokens)],
           pos = where)
  }
}
