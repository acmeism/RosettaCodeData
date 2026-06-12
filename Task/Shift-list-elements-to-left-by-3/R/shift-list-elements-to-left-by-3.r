rotate_vector <- function(v, n) {
  if (n == 0) v else c(tail(v, -n), head(v, n))
}

rotate_vector(1:9, 3)
