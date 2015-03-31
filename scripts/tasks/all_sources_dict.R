
# Ngrams for every token

# Load used packages
library(package = dplyr) # For lag.default
library(package = data.table) # for operation



# Load tokens
load(file = "./data/pre-proc/01_token_news.Rdata")
load(file = "./data/pre-proc/01_token_blogs.Rdata")
load(file = "./data/pre-proc/01_token_twitter.Rdata")


# Save all tokens together
token_all <- c(token_news, token_blogs, token_twitter)


# Source the ngram function
source(file = "./R/ngrams.R")



#------------------------------------------------------------------------------*
# 2-, 3- and 4-gram counts
#------------------------------------------------------------------------------*

# Number of parameters
param <- 4

# All token sources
microbenchmark::microbenchmark(
  times = 1,
  ngrams(tokens = token_all, maxn = param, tag = "all")
)


# Save all tokens and ngrams
save(token_all, file = "./data/processed/02_tokens_all.RData")
save(n1_all, n2_all, n3_all, n4_all, file = "./data/processed/02_ngrams_all.RData")
