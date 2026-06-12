poly_deriv <- function(v){
  n <- length(v)
  deriv <- c()
  if (n>1){
    i <- 1
    for (val in v[2:n]){
      deriv <- c(deriv, i*val)
      i <- i+1
    }
  }
  print(deriv)
}

test_polys <- list(5, c(4, -3), c(-1, 6, 5), c(-4, 3, -2, 1), c(1, 1, 0, -1, -1))
derivs <- sapply(test_polys, poly_deriv)
