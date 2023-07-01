spiral <- function(n) matrix(order(cumsum(rep(rep_len(c(1, n, -1, -n), 2 * n - 1), n - seq(2 * n - 1) %/% 2))), n, byrow = T) - 1

spiral(5)
