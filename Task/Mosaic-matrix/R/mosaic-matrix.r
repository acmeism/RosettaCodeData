mosaic <- function(n){
  x <- ifelse(n%%2==0, n+1, n)
  mat <- matrix(c(rep(c(1, 0), times=x^2%/%2), 1), nrow=x)
  mat[1:n, 1:n]
}

mosaic(7)
mosaic(8)
