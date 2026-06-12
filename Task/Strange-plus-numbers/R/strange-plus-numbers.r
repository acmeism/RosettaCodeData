# Primes up to 18
pr <- sapply(1:18, \(n) n > 1 && all(n %% seq(2, length.out = n - 2) > 0))

is.strange <- function(n) {
  a <- as.integer(strsplit(as.character(n), "")[[1]])
  pr[a[[1]] + a[[2]] + 1] && pr[a[[2]] + a[[3]] + 1]
}

a <- 101:499
a[sapply(a, is.strange)]
