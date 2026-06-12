walsh <- function(n) {
  if (n == 1) {
    cbind(c(1, 1), c(1, -1))
  } else kronecker(walsh(1), walsh(n-1))
}

walsh(4)
