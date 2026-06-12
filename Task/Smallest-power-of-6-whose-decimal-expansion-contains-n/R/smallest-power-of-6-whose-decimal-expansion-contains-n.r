library(gmp)

smallest_six <- function(n) {
  p <- as.bigz(1)
  lg <- 0
  while (!grepl(n, p)) {
    p <- 6*p
    lg <- lg+1
  }
  list("n" = n, "exponent" = lg, "power" = p)
}

pretty_six <- function(n) do.call(sprintf, c("%i: 6^%i = %s", smallest_six(n)))

writeLines(sapply(0:21, pretty_six))
