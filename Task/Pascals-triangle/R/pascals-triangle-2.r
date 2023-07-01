pascalTriangle <- function(h) {
  lapply(0:h, function(i) choose(i, 0:i))
}
