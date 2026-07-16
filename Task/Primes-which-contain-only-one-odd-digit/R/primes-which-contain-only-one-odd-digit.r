library(gmp)

odds <- c(1, 3, 5, 7, 9)
evens <- c(0, 2, 4, 6, 8)

#The odd digit must be the last one and can't be 5 (unless the number is just 5)
last_odd <- function(nd) {
  lapply(nd:1 - 1, function(x) rep(if (x) evens else odds, each = 5^x)) |>
    do.call(paste0, args = _) |>
    grepv("(^0+5|[^5])$", x = _) |>
    as.numeric()
}

cat(
  "Primes with only one odd digit below 1000 are:",
  Filter(isprime, last_odd(3)),
  "\nThere are",
  Filter(isprime, last_odd(6)) |> length(),
  "primes with only one odd digit below one million."
)
