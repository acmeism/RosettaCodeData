n <- function(x) function()x

A <- function(k, x1, x2, x3, x4, x5) {
  B <- function() A(k <<- k-1, B, x1, x2, x3, x4)
  if (k <= 0) x4() + x5() else B()
}

A(10, n(1), n(-1), n(-1), n(1), n(0))
