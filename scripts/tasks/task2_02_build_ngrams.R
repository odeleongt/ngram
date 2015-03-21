#------------------------------------------------------------------------------*
# Building ngrams
#------------------------------------------------------------------------------*

# Load used packages
library(package = dplyr) # For lag.default
library(package = data.table) # for operation

# Clear the working environment
rm(list = ls()[!grepl("token", ls())])

# Load tokens
load(file = "./data/pre-proc/01_token_news.Rdata")
load(file = "./data/pre-proc/01_token_blogs.Rdata")
load(file = "./data/pre-proc/01_token_twitter.Rdata")



#------------------------------------------------------------------------------*
# 2-, 3- and 4-gram counts
#------------------------------------------------------------------------------*


# News
begin <- Sys.time()

n_grams_news <- data.table(n0 = unlist(lapply(token_news, c, NA, NA, NA)))
n_grams_news <- n_grams_news[, n1 := lag(n0, n = 1)]
n_grams_news <- n_grams_news[, n2 := lag(n1, n = 1)]
n_grams_news <- n_grams_news[, n3 := lag(n2, n = 1)][!is.na(n0)]

n4_news <- n_grams_news[, .N, by="n3,n2,n1,n0"]
n3_news <- n4_news[, list(N = sum(N)), by="n2,n1,n0"]
n2_news <- n3_news[, list(N = sum(N)), by="n1,n0"]
n1_news <- n2_news[, list(N = sum(N)), by="n0"]

n4_news <- n4_news[complete.cases(n4_news)]
n3_news <- n3_news[complete.cases(n3_news)]
n2_news <- n2_news[complete.cases(n2_news)]

setkey(n4_news, n3, n2, n1, n0)
setkey(n3_news, n2, n1, n0)
setkey(n2_news, n1, n0)
setkey(n1_news, n0)

end <- Sys.time()

# Total elapsed time
cat("News time: ")
end-begin



# Blogs
begin <- Sys.time()

n_grams_blogs <- data.table(n0 = unlist(lapply(token_blogs, c, NA, NA)))
n_grams_blogs <- n_grams_blogs[, n1 := lag(n0, n = 1)]
n_grams_blogs <- n_grams_blogs[, n2 := lag(n1, n = 1)][!is.na(n0)]

n3_blogs <- n_grams_blogs[, .N, by="n2,n1,n0"]
n2_blogs <- n3_blogs[, list(N = sum(N)), by="n1,n0"]
n1_blogs <- n2_blogs[, list(N = sum(N)), by="n0"]

setkey(n3_blogs, n2, n1, n0)
setkey(n2_blogs, n1, n0)
setkey(n1_blogs, n0)

end <- Sys.time()

# Total elapsed time
cat("Blogs time: ")
end-begin


# Twitter
begin <- Sys.time()

n_grams_twitter <- data.table(n0 = unlist(lapply(token_twitter, c, NA, NA)))
n_grams_twitter <- n_grams_twitter[, n1 := lag(n0, n = 1)]
n_grams_twitter <- n_grams_twitter[, n2 := lag(n1, n = 1)][!is.na(n0)]

n3_twitter <- n_grams_twitter[, .N, by="n2,n1,n0"]
n2_twitter <- n3_twitter[, list(N = sum(N)), by="n1,n0"]
n1_twitter <- n2_twitter[, list(N = sum(N)), by="n0"]

setkey(n3_twitter, n2, n1, n0)
setkey(n2_twitter, n1, n0)
setkey(n1_twitter, n0)

end <- Sys.time()

# Total elapsed time
cat("Twitter time: ")
end-begin


# Save
save(list = grep("n[1-3]", ls(), value = TRUE),
     file = "./data/processed/02_ngrams.RData")
