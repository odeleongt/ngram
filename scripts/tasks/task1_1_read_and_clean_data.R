#------------------------------------------------------------------------------*
# Read the data files
#------------------------------------------------------------------------------*

# Blogs
blogs_con <- file("./data/raw/final/en_US/en_US.blogs.txt", open = "rb")
blogs <- readLines(con = blogs_con)
close(blogs_con)
rm(blogs_con)
format(object.size(blogs), units = "MB")


# News
news_con <- file("./data/raw/final/en_US/en_US.news.txt", open = "rb")
news <- readLines(con = news_con)
close(news_con)
rm(news_con)
format(object.size(news), units = "MB")


# Twitter  
twitter_con <- file("./data/raw/final/en_US/en_US.twitter.txt",
                    open = "rb")
twitter <- readLines(con = twitter_con)
close(twitter_con)
rm(twitter_con)
format(object.size(twitter), units = "MB")


# Capture warnings and check out the problems
warns <- names(warnings())
cat(twitter[as.integer(sub("^line ([0-9]*) .*", "\\1", warns))], sep = "\n\n")


#------------------------------------------------------------------------------*
# Fix encoding problems
#------------------------------------------------------------------------------*

# Fix encoding
news <- iconv(news, from="UTF-8", to="latin1", sub=" ")
blogs <- iconv(blogs, from="UTF-8", to="latin1", sub=" ")
twitter <- iconv(twitter, from="UTF-8", to="latin1", sub=" ")

# Check warns
cat(twitter[as.integer(sub("^line ([0-9]*) .*", "\\1", warns))], sep = "\n\n")


# Export data
save(news, blogs, twitter,
     file = "./data/pre-proc/intermediate/01_fix_encoding.RData")



#------------------------------------------------------------------------------*
# Basic cleaning tasks
#------------------------------------------------------------------------------*

# Get function to clean text
source(file = "./R/clean_text.R")

# News
microbenchmark::microbenchmark(times = 1, fixed_news <- clean_text(news))

# Blogs
microbenchmark::microbenchmark(times = 1, fixed_blogs <- clean_text(blogs))

# Twitter
microbenchmark::microbenchmark(times = 1, fixed_twitter <- clean_text(twitter))

# Save clean texts
save(fixed_news, fixed_blogs, fixed_twitter,
     file = "./data/pre-proc/intermediate/02_clean_text.RData")
