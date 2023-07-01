horner <- function(a, x) {
  y <- 0
  for(c in rev(a)) {
    y <- y * x + c
  }
  y
}

cat(horner(c(-19, 7, -4, 6), 3), "\n")
