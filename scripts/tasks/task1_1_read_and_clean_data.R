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


# Isolate contractions
punct <- "'([^[:space:]']*)"
repl <- " \t\\1\t "
fixed_news <- gsub(pattern = punct, replacement = repl, x = news)
fixed_blogs <- gsub(pattern = punct, replacement = repl, x = blogs)
fixed_twitter <- gsub(pattern = punct, replacement = repl, x = twitter)


# Remove punctuation (keep hashtags)
punct <- "[^#[:alnum:][:space:]]+"
repl <- " "
fixed_news <- gsub(pattern = punct, replacement = repl, x = fixed_news)
fixed_blogs <- gsub(pattern = punct, replacement = repl, x = fixed_blogs)
fixed_twitter <- gsub(pattern = punct, replacement = repl, x = fixed_twitter)


# Restore contractions
punct <- "\t([^\t]*)\t"
repl <- "'\\1"
fixed_news <- gsub(pattern = punct, replacement = repl, x = fixed_news)
fixed_blogs <- gsub(pattern = punct, replacement = repl, x = fixed_blogs)
fixed_twitter <- gsub(pattern = punct, replacement = repl, x = fixed_twitter)


# Use generic number marker
punct <- "[[:space:]]*[0-9]+[[:space:]]*(?R)?"
repl <- " {digits} "
fixed_news <- gsub(pattern = punct, replacement = repl, x = fixed_news, perl=TRUE)
fixed_blogs <- gsub(pattern = punct, replacement = repl, x = fixed_blogs, perl=TRUE)
fixed_twitter <- gsub(pattern = punct, replacement = repl, x = fixed_twitter, perl=TRUE)


# Reduce #s single copy
punct <- "([[:alpha:][]]])?#+"
repl <- "\\1 #"
fixed_news <- gsub(pattern = punct, replacement = repl, x = fixed_news)
fixed_blogs <- gsub(pattern = punct, replacement = repl, x = fixed_blogs)
fixed_twitter <- gsub(pattern = punct, replacement = repl, x = fixed_twitter)


# Remove lone #s
punct <- "(^| )#( |$)"
repl <- " "
fixed_news <- gsub(pattern = punct, replacement = repl, x = fixed_news)
fixed_blogs <- gsub(pattern = punct, replacement = repl, x = fixed_blogs)
fixed_twitter <- gsub(pattern = punct, replacement = repl, x = fixed_twitter)


# Reduce spaces single copy
punct <- "[[:space:]]+"
repl <- " "
fixed_news <- gsub(pattern = punct, replacement = repl, x = fixed_news)
fixed_blogs <- gsub(pattern = punct, replacement = repl, x = fixed_blogs)
fixed_twitter <- gsub(pattern = punct, replacement = repl, x = fixed_twitter)


# Remove leading or trailing spaces
punct <- "(^[[:space:]])|([[:space:]]$)"
repl <- ""
fixed_news <- gsub(pattern = punct, replacement = repl, x = fixed_news)
fixed_blogs <- gsub(pattern = punct, replacement = repl, x = fixed_blogs)
fixed_twitter <- gsub(pattern = punct, replacement = repl, x = fixed_twitter)


# Everything to lower case
fixed_news <- tolower(fixed_news)
fixed_blogs <- tolower(fixed_blogs)
fixed_twitter <- tolower(fixed_twitter)


# Fix some particular contractions

punct <- "ain 't"
repl <- "i am not"
fixed_news <- gsub(pattern = punct, replacement = repl, x = fixed_news)
fixed_blogs <- gsub(pattern = punct, replacement = repl, x = fixed_blogs)
fixed_twitter <- gsub(pattern = punct, replacement = repl, x = fixed_twitter)


punct <- "won 't"
repl <- "will not"
fixed_news <- gsub(pattern = punct, replacement = repl, x = fixed_news)
fixed_blogs <- gsub(pattern = punct, replacement = repl, x = fixed_blogs)
fixed_twitter <- gsub(pattern = punct, replacement = repl, x = fixed_twitter)


punct <- "can 't"
repl <- "can not"
fixed_news <- gsub(pattern = punct, replacement = repl, x = fixed_news)
fixed_blogs <- gsub(pattern = punct, replacement = repl, x = fixed_blogs)
fixed_twitter <- gsub(pattern = punct, replacement = repl, x = fixed_twitter)


punct <- "n 't"
repl <- " n't"
fixed_news <- gsub(pattern = punct, replacement = repl, x = fixed_news)
fixed_blogs <- gsub(pattern = punct, replacement = repl, x = fixed_blogs)
fixed_twitter <- gsub(pattern = punct, replacement = repl, x = fixed_twitter)


save(fixed_news, fixed_blogs, fixed_twitter,
     file = "./data/pre-proc/intermediate/02_clean_text.RData")
