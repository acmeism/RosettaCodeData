library(gmp)

conjunct <- function(f, g) function(x) f(x) & g(x)

wieferich <- function(p) {
  as.bigz(p) |> (function(x) (2^(x-1) - 1) %% (x^2) == 0)()
}

cat(Filter(conjunct(isprime, wieferich), 1:5000))
