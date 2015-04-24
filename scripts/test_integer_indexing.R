library(package = ff)
library(package = ffbase)
library(package = data.table)

ffload("C:/Users/odeleon/Desktop/shinyapps/ngram/data/processed/n4_ff")
load("C:/Users/odeleon/Desktop/shinyapps/ngram/data/processed/index.RData")

lev <- index[c("president", "of", "the", "united"), level]


N <- nrow(n4_ff) # Dataset size
n <- 1e6 # Chunk size

# process chunks and write to bit object
microbenchmark::microbenchmark(
  times = 100,
  ffbit <- {
    fn3 <- bit(N)
    fn2 <- bit(N)
    fn1 <- bit(N)
    fn0 <- bit(N)
    for (i in chunk(1,N,n)){
      fn3[i] <- n4_ff$n3[i] == lev[1]
      fn2[i] <- n4_ff$n2[i] == lev[2]
      fn1[i] <- n4_ff$n1[i] == lev[3]
      fn0[i] <- n4_ff$n0[i] == lev[4]
    }
    biti <- fn3 & fn2 & fn1 & fn0
    if(any(biti)){
      data.table(as.ram(n4_ff[biti, c("n0", "N")]))
    } else {
      data.table(n0=integer(0), N = integer(0))
    }
  },
  ffbase <- data.table(as.ram(subset(n4_ff, n3==lev[1] & n2==lev[2] &
                                       n1==lev[3] & n0==lev[4],
                                     select = c("n0", "N"))))
)




subset(n4_ff, n3==lev[1] & n2==lev[2] & n1==lev[3]& n0==lev[4])
