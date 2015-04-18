
# Load used packages
library(package = data.table)
library(package = parallel)


# Get interesting words
load(file = "./data/thesaurus/common_words.RData")
load(file = "./data/processed/02_tokens_all.RData")


# Only use referenced words
words <- words[!is.na(type)]



# Add words from the quizzes to the bagg
quiz2 <- c("when", "breathe", "want", "be", "air", "for", "ll", "there", 
           "live", "guy", "at", "my", "table", "s", "wife", "got", "up", 
           "go", "bathroom", "asked", "about", "dessert", "he", "started", 
           "telling", "me", "his", "give", "anything", "see", "arctic", 
           "monkeys", "this", "talking", "your", "mom", "has", "same", "effect", 
           "as", "hug", "helps", "reduce", "were", "holland", "{digits}", 
           "inch", "away", "but", "had", "time", "take", "just", "all", 
           "these", "questions", "answered", "presentation", "evidence", 
           "jury", "settle", "can", "deal", "with", "unsymetrical", "things", 
           "even", "hold", "an", "uneven", "number", "bags", "groceries", 
           "each", "every", "is", "perfect", "bottom", "m", "thankful", 
           "childhood", "was", "filled", "imagination", "bruises", "playing", 
           "how", "people", "are", "almost", "adam", "sandler")


ref <- unique(c(words$word, quiz2))
rm(words, quiz2)
n <- 2


# Set up the clusters
cl <- makeCluster(8)


# Split the data
factor <- rep(1:(8*4), each=ceiling(length(token_all) / 8 / 4))[1:length(token_all)]
tokens <- split(token_all, factor)
rm(token_all)
gc()


# # Only use tokens listed in `ref`
clusterExport(cl = cl, varlist = c("n"))#, "ref"))
# tokens <- parLapply(cl, tokens,
#                     function(chunk) lapply(chunk,
#                                            function(token) token[token %in% ref]))
# 
# gc()


# Only use token groups with enough elements
tokens <- parLapply(cl, tokens, function(chunk) chunk[sapply(chunk, length)>=n])
gc()



# Clear and set up the clusters again
stopCluster(cl)
gc()
cl <- makeCluster(8)
clusterExport(cl = cl, varlist = c("n"))
all(parLapply( cl, 1:length(cl), function(xx){
    require("data.table" , character.only=TRUE)
}))


# Process tokens into n-bags
bags <- parLapply(
  cl,
  tokens,
  function(chunk){
    bags <- lapply(X = chunk, FUN = function(x) combn(x, m = n, simplify = FALSE))
    
    # Clear some memory
    rm(chunk)
    gc()
    
    # Set default column names, rearrange data and aggregate into a data.table
    columns <- paste(paste0("V", seq(1,n)), collapse = ",")
    bags <- data.table(matrix(unlist(bags), ncol = n, byrow=TRUE))[, .N, by=columns][N > 1]
    
    # Rename columns and return
    tknames <- paste0("t", seq(1, n))
    setnames(bags, c(tknames, "N"))
    
    gc()
    bags
  })


# Stop the clusters and clean
stopCluster(cl)
gc()


# Bind the data.tables
bags <- rbindlist(bags)
setkey(bags, t1, t2)
bags <- bags[, list(N=sum(N)), by = "t1,t2"]


# Save the results
# save(n2_bags, file = "./data/processed/02_n2_bags.Rdata")
save(n2_bags_all, file = "./data/processed/02_n2_bags_all.Rdata")


# Clean up
rm(n2_bags, n2_bags_all)
gc()
