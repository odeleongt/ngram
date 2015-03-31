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




# Get interesting words
load(file = "./data/thesaurus/common_words.RData")


# Only use referenced words
words <- words[!is.na(type)]


# Save some counts for description
invisible(
  sapply(
    X =  grep(paste0("n[1-", param, "]"), ls(), value = TRUE),
    FUN = function(data){
      temp <- get(data)[order(-N)][1:20]
      saveRDS(temp,
           file = paste0("./data/processed/top-grams/", data, ".rds"))
      temp <- get(data)[n0 %in% uwords][order(-N)][1:20]
      saveRDS(temp,
           file = paste0("./data/processed/top-grams/thes_", data, ".rds"))
    }))
