library(gmp)

first_integer <- function(bigv, n) {
  for (q in bigv) {
    if (denominator(n*q) == 1) return(q)
  }
}

fractran <- function(s, n, lim) {
  fracs <- strsplit(s, " ") |>
    unlist() |>
    strsplit("/") |>
    sapply(function(v) as.bigq(n = v[1], d = v[2]))
  iters <- 0
  while (!is.null(first_integer(fracs, n))) {
    n <- n*first_integer(fracs, n)
    cat(sprintf("%s ", n))
    iters <- iters+1
    if (iters >= lim) break
  }
}

#Test input
fractran_primes <- "17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1"
fractran(fractran_primes, 2, 15)
