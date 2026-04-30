shoelace <- function(...){
  coords <- list(...)
  x <- sapply(coords, function(v) v[1])
  y <- sapply(coords, function(v) v[2])
  left <- sum(x*c(y[-1], y[1]))
  right <- sum(y*c(x[-1], x[1]))
  abs(left-right)/2
}

shoelace(c(3, 4), c(5, 11), c(12, 8), c(9, 5), c(5, 6))
