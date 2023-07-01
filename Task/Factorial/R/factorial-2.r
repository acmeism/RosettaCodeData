factIter <- function(n) {
  f = 1
  if (n > 1) {
    for (i in 2:n) f <- f * i
  }
  f
}
