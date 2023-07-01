hamming <- function(n) {
  a <- numeric(n)
  a[1] <- 1
  for (i in 2:n) {
    a[i] <- nextn(a[i-1]+1)
  }
  a
}
