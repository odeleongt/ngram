#------------------------------------------------------------------------------*
# Why not keep a 1MB index
#------------------------------------------------------------------------------*

# Load used packages
library(package = dplyr)
library(package = data.table)
library(package = ff)

# All n-grams
load(file = "./data/processed/02_ngrams_all.RData")

# Top words in 
top_mb <- n1_all[order(-N)][, list(n0)][1:16656]
top_mb[, level := 1:nrow(top_mb)]
class(top_mb) <- c(class(top_mb), "factdict")
setnames(top_mb, "n0", "word")
setkey(top_mb, word)

# Almost one MB
1024*1024 - object.size(top_mb)

# Store it
save(top_mb, file = "./data/processed/top_mb_comp.RData")
save(top_mb, file = "./data/processed/top_mb.RData", compress = FALSE)
saveRDS(top_mb, file = "./data/processed/top_mb.rds", compress = FALSE)


# Test load times -- use uncompressed rds file
microbenchmark::microbenchmark(
  times = 1000,
  comp_rdata = load("./data/processed/top_mb_comp.RData"),
  bare_rdata = load("./data/processed/top_mb.RData"),
  bare_rds = index <- readRDS("./data/processed/top_mb.rds")
)


# Reverse searching
xedni <- copy(index)
setkey(xedni, level)

# Cleanup
rm(top_mb)



# Test lookup times -- use j lexic
microbenchmark::microbenchmark(
  times = 1000,
  j = index["test", level],
  r = index["test"]$level
)



# Test multi lookup times --- better look for multiple words at the same time
set.seed(2015-03-23)
tests <- sample(index$word, 10)
tests
microbenchmark::microbenchmark(
  times = 100,
  once = index[tests[1], level],
  twice = index[tests[c(1,1)], level],
  '2' = index[tests[1:2], level],
  '3' = index[tests[1:3], level],
  '4' = index[tests[1:4], level],
  '5' = index[tests[1:5], level],
  '6' = index[tests[1:6], level],
  '7' = index[tests[1:7], level],
  '8' = index[tests[1:8], level],
  '9' = index[tests[1:9], level],
  '10' = index[tests[1:10], level]
)


# Limit n-grams to those containing words in the index in the first (n-1) tokens

n1_index <- n1_all[n0 %in% index$word]
setkey(n1_index, n0)
format(object.size(n1_index) - object.size(n1_all), units="Mb")



n2_index <- n2_all[n0 %in% index$word & n1 %in% index$word]
setkey(n2_index, n1)
format(object.size(n2_index) - object.size(n2_all), units="Mb")



n3_index <- n3_all[n0 %in% index$word & n1 %in% index$word & n2 %in% index$word]
setkey(n3_index, n2, n1)
format(object.size(n3_index) - object.size(n3_all), units="Mb")



n4_index <- n4_all[n0 %in% index$word & n1 %in% index$word & n2 %in% index$word & n3 %in% index$word]
setkey(n4_index, n3, n2, n1)
format(object.size(n4_index) - object.size(n4_all), units="Mb")


# Clean up
rm(n1_all, n2_all, n3_all, n4_all)
gc()


# Filter out [most] uncommon n-grams

quantile(n2_index$N, p=seq(0,1,by=0.05)) ## Seems like > 5 would likely cut it
quantile(n3_index$N, p=seq(0,1,by=0.05)) ## Seems like > 10 would likely cut it
quantile(n4_index$N, p=seq(0,1,by=0.05)) ## Seems like > 5 would likely cut it


# Test dictionary size
ngram_freq_cutoff_size <-
  lapply(X = 0:100,
         FUN = function(n){
           n2 <- n2_index[N>n]
           n3 <- n3_index[N>n]
           n4 <- n4_index[N>n]
           
           data.table(params = c(2, 3, 4),
                      n = n,
                      rows = c(nrow(n2), nrow(n3), nrow(n4)),
                      size = c(format(object.size(n2), units="Mb"),
                               format(object.size(n3), units="Mb"),
                               format(object.size(n4), units="Mb")))
         })
ngram_freq_cutoff_size <- rbindlist(ngram_freq_cutoff_size)
ngram_freq_cutoff_size[, size := as.numeric(sub("([0-9.]*)[^0-9]*", "\\1", size))]
save(ngram_freq_cutoff_size, file = "./data/processed/01_ngram_freq_cutoff_size.Rdata")


library(package = ggplot2)
ref_values <-  c(range(c(min(ngram_freq_cutoff_size$size), 1, 10)),
                 50, 25, 100, 1000,
                 max(ngram_freq_cutoff_size$size))
ggplot(data = ngram_freq_cutoff_size,
       aes(x = n, y = size, color = factor(params))) +
  geom_hline(color = "grey90", size = 1, linetype = "dashed",
             yintercept = ref_values) +
  geom_line(size = 1) +
  labs(x = "Minimum frequency for inclusion",
       y = "Dictionary size (MB of RAM used)",
       color = "Number of parameters") +
  scale_y_log10(breaks = ref_values, limits = range(ngram_freq_cutoff_size$size)) +
  theme_classic() +
  theme(legend.position = "bottom")

ggsave(filename = "MG_ngram_dict.svg", plot = last_plot(), width = 6, height = 4)

# 50M for each dictionary seems about right
cuts <- ngram_freq_cutoff_size[between(size-50, -10, 0)][order(params)]

n2_index_top <- n2_index[N > cuts[params == 2, n]]
format(object.size(n2_index), units="Mb")
format(object.size(n2_index_top), units="Mb")



n3_index_top <- n3_index[N > cuts[params == 3, n]]
format(object.size(n3_index), units="Mb")
format(object.size(n3_index_top), units="Mb")



n4_index_top <- n4_index[N > cuts[params  ==4, n]]
format(object.size(n4_index), units="Mb")
format(object.size(n4_index_top), units="Mb")



# Try to set factor levels for equivalent ff_df objects

n1_factor <-copy(n1_index)
n1_factor[index, n0:=level]
n1_factor$n0 <- as.integer(n1_factor$n0)
setkey(n1_factor, n0)
n1_factor[xedni]

# For n2
n2_factor <- copy(n2_index_top)
n2_factor[index, n1:=level, allow.cartesian = TRUE]
n2_factor$n1 <- as.integer(n2_factor$n1)
setkey(n2_factor, n0)
n2_factor[index, n0:=level, allow.cartesian = TRUE]
n2_factor$n0 <- as.integer(n2_factor$n0)
n2_factor$n1 <- as.ushort(n2_factor$n1)
n2_factor$n0 <- as.ushort(n2_factor$n0)

n2_ff <- as.ffdf(n2_factor)
ffsave(n2_ff, file = "./data/processed/n2_ff", compress = FALSE)

setkey(n2_factor, n1)
n2_factor[xedni, , allow.cartesian = TRUE]



# For n3
n3_factor <- copy(n3_index_top)
n3_factor[index, n2:=level, allow.cartesian = TRUE]
n3_factor$n2 <- as.integer(n3_factor$n2)
setkey(n3_factor, n1)
n3_factor[index, n1:=level, allow.cartesian = TRUE]
n3_factor$n1 <- as.integer(n3_factor$n1)
setkey(n3_factor, n0)
n3_factor[index, n0:=level, allow.cartesian = TRUE]
n3_factor$n0 <- as.integer(n3_factor$n0)

n3_factor$n2 <- as.ushort(n3_factor$n2)
n3_factor$n1 <- as.ushort(n3_factor$n1)
n3_factor$n0 <- as.ushort(n3_factor$n0)

n3_ff <- as.ffdf(n3_factor)
ffsave(n3_ff, file = "./data/processed/n3_ff", compress = FALSE)

setkey(n3_factor, n0)
n3_factor[xedni, , allow.cartesian = TRUE]




# For n4
n4_factor <- copy(n4_index_top)

n4_factor[index, n3:=level, allow.cartesian = TRUE]
n4_factor$n3 <- as.integer(n4_factor$n3)
setkey(n4_factor, n1)
n4_factor[index, n2:=level, allow.cartesian = TRUE]
n4_factor$n2 <- as.integer(n4_factor$n2)
setkey(n4_factor, n1)
n4_factor[index, n1:=level, allow.cartesian = TRUE]
n4_factor$n1 <- as.integer(n4_factor$n1)
setkey(n4_factor, n0)
n4_factor[index, n0:=level, allow.cartesian = TRUE]
n4_factor$n0 <- as.integer(n4_factor$n0)

n4_factor$n3 <- as.ushort(n4_factor$n3)
n4_factor$n2 <- as.ushort(n4_factor$n2)
n4_factor$n1 <- as.ushort(n4_factor$n1)
n4_factor$n0 <- as.ushort(n4_factor$n0)

n4_ff <- as.ffdf(n4_factor)
ffsave(n4_ff, file = "./data/processed/n4_ff", compress = FALSE)

setkey(n4_factor, n0)
n4_factor[xedni, , allow.cartesian = TRUE]



# Save indexes
save(index, xedni, file = "./data/processed/index.RData")
