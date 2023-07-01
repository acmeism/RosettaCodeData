zigzag2 <- function(n) {
  a <- zigzag1(n)
  v <- seq(n - 1)^2
  for (i in seq(n - 1)) {
    a[n - i + 1, seq(i + 1, n)] <- a[n - i + 1, seq(i + 1, n)] - v[seq(n - i)]
  }
  a
}

zigzag2(5)
