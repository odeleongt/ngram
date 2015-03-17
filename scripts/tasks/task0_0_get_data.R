#------------------------------------------------------------------------------*
# Get data from the coursera site
#------------------------------------------------------------------------------*

# Provided URI
uri <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
file <- "./data/raw/Coursera-SwiftKey.zip"

# Get data if it is not already available
if(!file.exists(file)){
  download.file(url = uri, destfile = file, mode = "wb")
}




#------------------------------------------------------------------------------*
# Extract the data from the downloaded file
#------------------------------------------------------------------------------*

if(file.exists(file)){
  unzip(zipfile = file, exdir = "./data/raw/")
} else {
  stop(paste0("File not found.\n", normalizePath(file)))
}

