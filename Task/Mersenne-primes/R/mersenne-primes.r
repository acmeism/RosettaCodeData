library(gmp)

cat(Filter(function(x) isprime(2^as.bigz(x) - 1), 1:5000))
