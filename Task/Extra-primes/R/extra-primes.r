library(gmp)

digsum <- function(n, nd) sum((n %/% (10^(1:nd - 1))) %% 10)

smarandache <- function(nd) {
  p <- c(2, 3, 5, 7)
  if (nd == 1) p
  else lapply(nd:1 - 1, function(x) rep(p, each = 4^x)) |>
    do.call(paste0, args = _) |>
    grepv("[37]$", x = _) |>
    as.numeric()
}

extraprimes <- function(maxd) {
  lapply(1:maxd, smarandache) |>
    unlist() |>
    Filter(isprime, x = _) |>
    Filter(function(p) isprime(digsum(p, 4)), x = _)
}

options(width = 50)
extraprimes(4)
