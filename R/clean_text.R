#' Prepare text for tokenizing
#' 
#' Input text will usually have some non desired or non standard features,
#' such as unwanted characters or uninformative tokens (\emph{e.g.} numbers).
#' This function processes a \code{character} vector using regular expressions
#' and outputs a clean vector with alphanumeric characters, a unique digits
#' placeholder and isolated or expanded contractions.
#' 
#' #' @seealso \code{\link{assign}}
#' @param text A character vector to process
#' #' @export
#' @examples
#' # Test text cleanup
#' corpus <- c("This is a test sentence", "This is another test")
#' clean <- clean_text(corpus)
clean_text <- function(text){
  # Separate sentences
  fixed_text <- unlist(stringi::stri_split(text, regex = " ?[.;:!?()]+ ?",
                                           omit_empty = TRUE))
  
  # Isolate contractions
  punct <- "'([^[:space:]']*)"
  repl <- " \t\\1\t "
  fixed_text <- gsub(pattern = punct, replacement = repl, x = fixed_text)
  
  # Remove punctuation (keep hashtags)
  punct <- "[^#a-zA-Z0-9[:space:]]+"
  repl <- " "
  fixed_text <- gsub(pattern = punct, replacement = repl, x = fixed_text)
  
  # Remove lone apostrophes
  punct <- "[[:space:]]\t[^a-zA-Z]*\t[[:space:]]"
  repl <- " "
  fixed_text <- gsub(pattern = punct, replacement = repl, x = fixed_text)
  
  # Remove hashtags
  punct <- "[[:space:]]*#[^[:space:]]*"
  repl <- " "
  fixed_text <- gsub(pattern = punct, replacement = repl, x = fixed_text)
  
  # Tag dates
  months <- c("January", "February", "March", "April", "May", "June",
              "July", "August", "September", "October", "November", "December")
  months <- paste0("(", paste(months, collapse="|"), ")")
  days <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
           "Saturday", "Sunday")
  days <- paste0("(", paste(days, collapse="|"), ")")
  ordinal <- c("st", "nd", "rd", "th")
  ordinal <- paste0("(", paste(ordinal, collapse="|"), ")")
  
  punct <- paste0("((", days, "[[:space:]]+", ")|",
                  "(", months, "[[:space:]]+", "))+",
                  "(the[[:space:]]+)?",
                  "([0-9]+([[:space:]]*", ordinal, "[. ])?)?",
                  "([[:space:]]*[0-9]+([a-zA-Z]+)?)*")
  repl <- " {date} "
  fixed_text <- gsub(pattern = punct, replacement = repl,
                     x = fixed_text, ignore.case = TRUE)
  
  # Tag addresses
  punct <- paste0("( on )*",
                  "[0-9]+[a-zA-Z[:space:]]*",
                  "([a-zA-Z0-9]+[[:space:]]+){0,3}",
                  "([Ss]treet| [Ss]t[. ]|blvd)[[:space:]]*[0-9]*")
  repl <- "\\1 {address} "
  fixed_text <- gsub(pattern = punct, replacement = repl,
                     x = fixed_text, ignore.case = TRUE)
  
  # Restore contractions
  punct <- "\t([^\t]*)\t"
  repl <- "'\\1"
  fixed_text <- gsub(pattern = punct, replacement = repl, x = fixed_text)
  
  # Use generic number marker
  punct <- "[[:space:]]*[0-9]+[[:space:]]*(?R)?"
  repl <- " {digits} "
  fixed_text <- gsub(pattern = punct, replacement = repl, x = fixed_text, perl=TRUE)
  
  # Reduce spaces single copy
  punct <- "[[:space:]]+"
  repl <- " "
  fixed_text <- gsub(pattern = punct, replacement = repl, x = fixed_text)
  
  # Remove leading or trailing spaces
  punct <- "(^[[:space:]])|([[:space:]]$)"
  repl <- ""
  fixed_text <- gsub(pattern = punct, replacement = repl, x = fixed_text)
  
  # Everything to lower case
  fixed_text <- tolower(fixed_text)
  
  # Fix some particular contractions
  punct <- "ain 't"
  repl <- "i am not"
  fixed_text <- gsub(pattern = punct, replacement = repl, x = fixed_text,
                     fixed = TRUE)
  
  punct <- "won 't"
  repl <- "will not"
  fixed_text <- gsub(pattern = punct, replacement = repl, x = fixed_text,
                     fixed = TRUE)
  
  punct <- "can 't"
  repl <- "can not"
  fixed_text <- gsub(pattern = punct, replacement = repl, x = fixed_text,
                     fixed = TRUE)
  
  punct <- "n 't"
  repl <- " not"
  fixed_text <- gsub(pattern = punct, replacement = repl, x = fixed_text,
                     fixed = TRUE)
  
  # Remove lone non alpha characters
  punct <- "[[:space:]]*[^a-zA-Z {}][[:space:]]*"
  repl <- " "
  fixed_text <- gsub(pattern = punct, replacement = repl, x = fixed_text)
  
  # Returned the fixed text
  return(fixed_text)
}
