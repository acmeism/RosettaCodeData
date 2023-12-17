digitsum <- function(x) sum(floor(x / 10^(0:(nchar(x) - 1))) %% 10)

is.prime <- function(n) n == 2L || all(n %% 2L:max(2,floor(sqrt(n))) != 0)

range_int <- 2:500
v <- sapply(range_int, \(x) is.prime(x) && is.prime(digitsum(x)))

cat(paste("Found",length(range_int[v]),"additive primes less than 500"))
print(range_int[v])
