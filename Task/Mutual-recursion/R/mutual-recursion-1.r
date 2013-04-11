F <- function(n) ifelse(n == 0, 1, n - M(F(n-1)))
M <- function(n) ifelse(n == 0, 0, n - F(M(n-1)))
