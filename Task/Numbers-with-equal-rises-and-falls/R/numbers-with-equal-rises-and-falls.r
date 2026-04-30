numdigits <- function(n) ifelse(log10(n)%%1==0,
                                1+log10(n),
                                ceiling(log10(n)))

eq_rises_falls <- function(n) {
  k <- numdigits(n)-1
  diffs <- diff(sapply(0:k, function(m) (n%/%10^m)%%10))
  sum(diffs > 0) == sum(diffs < 0)
}

count <- 0
n <- 1
cat("First 200 numbers:\n")
while(count < 10^7) {
  if(eq_rises_falls(n)) {
    count <- count+1
    if(count <= 200) cat(n, rep("\n", count%%20==0))
  }
  n <- n+1
}
cat("\n10,000,000th number:", n-1)
