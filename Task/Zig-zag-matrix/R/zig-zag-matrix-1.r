zigzag1 <- function(n) {
  j <- seq(n)
  u <- rep(c(-1, 1), n)
  v <- j * (2 * j - 1) - 1
  v <- as.vector(rbind(v, v + 1))
  a <- matrix(0, n, n)
  for (i in seq(n)) {
    a[i, ] <- v[j + i - 1]
    v <- v + u
  }
  a
}

zigzag1(5)
