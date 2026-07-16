library(gmp)

digsum <- function(n, nd) sum((n %/% (10^(1:nd - 1))) %% 10)

Filter(function(x) isprime(x) && digsum(x, 4) == 25, 1:5000) |> cat()
