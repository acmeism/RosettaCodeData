maybe_primes <- c(2, 43, 81, 122, 63, 13, 7, 95, 103)
test_divisors <- c(2, 3, 5, 7, 11)
primetest <- function(n) `|`(!(0 %in% (n%%test_divisors)),
                             n %in% test_divisors)
primes <- numeric(0)
for(i in maybe_primes){
  if(primetest(i)){
    primes <- c(primes, i)
    cat(sort(primes), "\r")
    Sys.sleep(1)
  }
}
