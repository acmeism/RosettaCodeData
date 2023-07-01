A <- call.by.name(x1, x2, x3, x4, x5,
  function(k, x1, x2, x3, x4, x5) {
    Aout <- NULL
    B <- function() {
      k <<- k - 1
      Bout <- Aout <<- A(k, B(), x1, x2, x3, x4)
    }
    if (k <= 0) Aout <- x4 + x5 else B()
    Aout
  }
)
