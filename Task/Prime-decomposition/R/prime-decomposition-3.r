findfactors <- function(n) {
  a <- NULL
  if (n > 1) {
    while (n %% 2 == 0) {
      a <- c(a, 2)
      n <- n %/% 2
    }
    k <- 3
    while (k * k <= n) {
      while (n %% k == 0) {
        a <- c(a, k)
        n <- n %/% k
      }
      k <- k + 2
    }
    if (n > 1) a <- c(a, n)
  }
  a
}
