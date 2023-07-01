fac <- function(f) {
  function(n) {
    if (n<2)
      1
    else
      n*f(n-1)
  }
}

fib <- function(f) {
  function(n) {
    if (n <= 1)
      n
    else
      f(n-1) + f(n-2)
  }
}
