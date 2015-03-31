
# Load used packages
library(package = data.table)


# Get interesting words
load(file = "./data/thesaurus/common_words.RData")
load(file = "./data/processed/02_tokens_all.RData")


# Only use referenced words
words <- words[!is.na(type)]


source("./R/nbags.R")

# Simple test cases
corpus <- c("This is a nice test sentence", "This is another test")
tokens <- strsplit(tolower(corpus), split = " ")


# Simple tests benchmarking
microbenchmark::microbenchmark(
  times = 100,
  "1" = nbags(tokens, n = 1L, ref = c("this", "test", "sentence", "another", "nice")),
  "2" = nbags(tokens, n = 2L, ref = c("this", "test", "sentence", "another", "nice")),
  "3" = nbags(tokens, n = 3L, ref = c("this", "test", "sentence", "another", "nice")),
  "4" = nbags(tokens, n = 4L, ref = c("this", "test", "sentence", "another", "nice"))
)



# Test with some tokens
set.seed(2015-03-28)
test_tokens <- sample(token_all, 100)



# Review output
nbags(test_tokens, n = 3L, ref = unique(words$word))


# Adding a token takes around 3ms
microbenchmark::microbenchmark(
  times = 100,
  "1" = nbags(test_tokens, n = 1L, ref = unique(words$word)),
  "2" = nbags(test_tokens, n = 2L, ref = unique(words$word)),
  "3" = nbags(test_tokens, n = 3L, ref = unique(words$word)),
  "4" = nbags(test_tokens, n = 4L, ref = unique(words$word)),
  "5" = nbags(test_tokens, n = 5L, ref = unique(words$word))
)



# Adding 10 sentences takes around 3ms
microbenchmark::microbenchmark(
  times = 100,
  "1" = nbags(test_tokens[1:10], n = 3L, ref = unique(words$word)),
  "2" = nbags(test_tokens[1:20], n = 3L, ref = unique(words$word)),
  "3" = nbags(test_tokens[1:30], n = 3L, ref = unique(words$word)),
  "4" = nbags(test_tokens[1:40], n = 3L, ref = unique(words$word)),
  "5" = nbags(test_tokens[1:50], n = 3L, ref = unique(words$word)),
  "6" = nbags(test_tokens[1:60], n = 3L, ref = unique(words$word)),
  "7" = nbags(test_tokens[1:70], n = 3L, ref = unique(words$word)),
  "8" = nbags(test_tokens[1:80], n = 3L, ref = unique(words$word)),
  "9" = nbags(test_tokens[1:90], n = 3L, ref = unique(words$word)),
  "10" = nbags(test_tokens[1:100], n = 3L, ref = unique(words$word))
)



microbenchmark::microbenchmark(
  times = 1,
  n2_bags <- nbags(token_all, n = 2L, ref = unique(words$word),
                    aggressive.gc = TRUE)
)

setkey(n2_bags, t1, t2)

save(n2_bags, file = "./data/processed/02_n2_bags_all.Rdata")



microbenchmark::microbenchmark(
  times = 1,
  n3_bags <- nbags(token_all, n = 3L, ref = unique(words$word),
                   aggressive.gc = TRUE)
)

setkey(n3_bags, t1, t2, t3)

save(n3_bags, file = "./data/processed/02_n3_bags_all.Rdata")


