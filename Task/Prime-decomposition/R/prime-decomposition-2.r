primes <- as.integer(c())

max_prime_checker <- function(n){
  divisor <<- NULL

  primes <- primes[primes <= n]

  for(i in 1:length(primes)){
    if((n/primes[i]) %% 1 == 0){
      divisor[i]<<-1
    } else {
      divisor[i]<<-0
    }
  }
  num_find <<- primes*as.integer(divisor)

  return(max(num_find))
}

#recursive prime finder
prime_factors <- function(n){

  factors <- NULL

  large <- max_prime_checker(n)
  n1 <- n/large

  if(max_prime_checker(n1) == n1){
    factors <- c(large,n1)
    return(factors)
  } else {
    factors <- c(large, prime_factors(n1))
    return(factors)
  }
}
