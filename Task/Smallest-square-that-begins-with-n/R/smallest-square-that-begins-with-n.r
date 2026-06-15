smallest_square <- function(n) {
  k <- 1
  while (!startsWith(as.character(k^2), as.character(n))) k <- k+1
  list("n" = n, "base" = k, "square" = k^2)
}

pretty_square <- function(n) {
  do.call(sprintf, c("%i: %i^2 = %i", smallest_square(n)))
}

writeLines(sapply(1:49, pretty_square))
