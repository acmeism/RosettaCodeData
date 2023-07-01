library(gmp) # for big integers

rand_BSD <- function(n = 1) {
  a <- as.bigz(1103515245)
  c <- as.bigz(12345)
  m <- as.bigz(2^31)
  x <- rep(as.bigz(0), n)
  x[1] <- (a * as.bigz(seed) + c) %% m
  i <- 1
  while (i < n) {
    x[i+1] <- (a * x[i] + c) %% m
    i <- i + 1
  }
  as.integer(x)
}

seed <- 0
rand_BSD(10)
##  [1]      12345 1406932606  654583775 1449466924  229283573 1109335178
##  [7] 1051550459 1293799192  794471793  551188310

rand_MS <- function(n = 1) {
  a <- as.bigz(214013)
  c <- as.bigz(2531011)
  m <- as.bigz(2^31)
  x <- rep(as.bigz(0), n)
  x[1] <- (a * as.bigz(seed) + c) %% m
  i <- 1
  while (i < n) {
    x[i+1] <- (a * x[i] + c) %% m
    i <- i + 1
  }
  as.integer(x / 2^16)
}

seed <- 0
rand_MS(10)
##  [1]    38  7719 21238  2437  8855 11797  8365 32285 10450 30612
