#------------------------------------------------------------------------------*
# Initial exploration of the datasets
#------------------------------------------------------------------------------*


# Load used packages
library(package = stringi)




#------------------------------------------------------------------------------*
# Tokenization
#------------------------------------------------------------------------------*

# load(file = "./data/pre-proc/intermediate/02_clean_text.RData")
rm(list = ls()[!grepl("fixed", ls())])

# Split tokens
token_news <- stri_split(str = fixed_news, regex = "[[:space:]]+")
token_blogs <- stri_split(str = fixed_blogs, regex = "[[:space:]]+")
token_twitter <- stri_split(str = fixed_twitter, regex = "[[:space:]]+")

# Save tokens
save(token_news, file = "./data/pre-proc/01_token_news.Rdata")
save(token_blogs, file = "./data/pre-proc/01_token_blogs.Rdata")
save(token_twitter, file = "./data/pre-proc/01_token_twitter.Rdata")



#------------------------------------------------------------------------------*
# Token description
#------------------------------------------------------------------------------*

# Characters per sentence
charsent_news <- stri_length(str = fixed_news)
charsent_blogs <- stri_length(str = fixed_blogs)
charsent_twitter <- stri_length(str = fixed_twitter)

# Tokens per sentence
ntoken_news <- sapply(X = token_news, FUN = length)
ntoken_blogs <- sapply(X = token_blogs, FUN = length)
ntoken_twitter <- sapply(X = token_twitter, FUN = length)

# Characters per token
nchar_news <- stri_length(str = unlist(token_news))
nchar_blogs <- stri_length(str = unlist(token_blogs))
nchar_twitter <- stri_length(str = unlist(token_twitter))

# Save count data
counts <- grep("char|ntok", ls(), value = TRUE)
save(list = counts, file = "./data/processed/01_describe_counts.RData")
rm(list = c(counts, "counts", grep("fixed", ls(), value = TRUE)))

