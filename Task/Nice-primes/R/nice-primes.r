dig_root <- function(n) ifelse(n>9, dig_root(n%%10+dig_root(n%/%10)), n)
#Only need to test divisibility up to 31 (1000 is less than 37 squared)
testdivisors <- c(2,3,5,7,11,13,17,19,23,29,31)
primetest <- function(n) !(0 %in% (n%%testdivisors))
primes <- Filter(primetest, 501:999)

primes[dig_root(primes) %in% c(2,3,5,7)]
