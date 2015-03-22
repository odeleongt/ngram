#------------------------------------------------------------------------------*
# Building ngrams
#------------------------------------------------------------------------------*

# Load used packages
library(package = dplyr) # For lag.default
library(package = data.table) # for operation

# Load tokens
load(file = "./data/pre-proc/01_token_news.Rdata")
load(file = "./data/pre-proc/01_token_blogs.Rdata")
load(file = "./data/pre-proc/01_token_twitter.Rdata")

# Clear the working environment
rm(list = ls()[!grepl("token", ls())])

# Source the ngram function
source(file = "./R/ngrams.R")




#------------------------------------------------------------------------------*
# 2-, 3- and 4-gram counts
#------------------------------------------------------------------------------*

# Number of parameters
param <- 4

# News
microbenchmark::microbenchmark(
  times = 1,
  ngrams(tokens = token_news, maxn = param, tag = "news")
)


# Blogs
microbenchmark::microbenchmark(
  times = 1,
  ngrams(tokens = token_blogs, maxn = param, tag = "blogs")
)


# Twitter
microbenchmark::microbenchmark(
  times = 1,
  ngrams(tokens = token_twitter, maxn = param, tag = "twitter")
)


# Save
save(list = grep(paste0("n[1-", param, "]"), ls(), value = TRUE),
     file = "./data/processed/02_ngrams.RData")
