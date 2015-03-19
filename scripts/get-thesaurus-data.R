#------------------------------------------------------------------------------*
# Get thesaurus information for language model compression and coverage expansion
#------------------------------------------------------------------------------*
# Use service provided by Big Huge Thesaurus (http://words.bighugelabs.com/) to
# obtain synonims and classification of words.
# This data will be used to expand the language model coverage (using synonyms
# to smooth the prediction of unknown words) and compressing the n-gram data set
# (by collapsing equivalent words to the most frequent instance)
#------------------------------------------------------------------------------*




#------------------------------------------------------------------------------*
# Setup api connection
# The api key is stored outside the repository since it is for private use, but
# other keys can be requested from: http://words.bighugelabs.com/api.php
#------------------------------------------------------------------------------*

# Read api key
# key <- scan(file = "./data/thesaurus-api-key", what = "character")

# Set connection url
uri <- paste0("http://words.bighugelabs.com/api/2/", key, "/")




#------------------------------------------------------------------------------*
# Perform some tests
#------------------------------------------------------------------------------*

# Set word
word <- "test"

# Get sample thesaurus data
plain_word <- readLines(con = url(paste0(url, word, "/"))) # plaintext
xml_word <- readLines(con = url(paste0(url, word, "/xml"))) # xml
xml_json <- readLines(con = url(paste0(url, word, "/json"))) # json
xml_php <- readLines(con = url(paste0(url, word, "/php"))) #serialized php

# Write sample results
writeLines(text = plain_word, con = "./data/sample/plain_word")
writeLines(text = xml_word, con = "./data/sample/xml_word")
writeLines(text = json_word, con = "./data/sample/json_word")
writeLines(text = php_word, con = "./data/sample/php_word")


rbindlist(list(read.table(text = plain_word, sep="|")))




#------------------------------------------------------------------------------*
# Get data for the common English words
#------------------------------------------------------------------------------*

# Load used packages
library(package = RCurl)
library(package = data.table)

# Get common English words
words <- readLines(con = "app/data/common-english-words")
words <- unlist(strsplit(words, split=", "))
words <- matrix(ncol=5, data=c(words, "shiny"))
names(words) <- words

# Get data from thesaurus
words <- lapply(X = words, FUN = function(word){
  getURL(url=paste0(uri, word, "/"))
})

# Set to NA the content of empty responses
words[words==""] <- "NA"

# Convert responses to a data.table
words <- data.table(
  plyr::ldply(.data = words, .id = "word",
              .fun = function(word){
                read.table(text = word, sep="|", stringsAsFactors = FALSE,
                           skipNul = TRUE, quote = "")
         }))

# Rename
words$word <- as.character(words$word)
setnames(words, c("word", "type", "group", "word2"))

# Tag to sort
words <- merge(
  data.table(order = 1:length(unique(words$word)), word = unique(words$word)),
  words, all.y = TRUE, by="word")

# Set keys
setkey(words, word)

# Save
# saveRDS(words, file = "./data/thesaurus/common_words.rds")
