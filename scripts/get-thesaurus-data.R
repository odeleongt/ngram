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
key <- scan(file = "../thesaurus-api-key", what = "character")

# Set connection url
url <- paste0("http://words.bighugelabs.com/api/2/", key, "/")



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

