sieve <- function(n) {
    if (n < 2)
        return (NULL)

    primes <- rep(TRUE, n)
    primes[1] <- FALSE

    for (i in 1:floor(sqrt(n)))
        if (primes[i])
            primes[seq(i*i, n, by = i)] <- FALSE

    which(primes)
}

prime.factors <- function(n) {
    primes <- sieve(floor(sqrt(n)))
    factors <- primes[n %% primes == 0]
    if (length(factors) == 0)
        n
    else {
        for (p in factors) { # add all elements of n/p that are also prime
            d <- n / p
            if (d != p && all(d %% primes[primes <= floor(sqrt(d))] != 0))
                factors <- c(factors, d)
        }
        factors
    }
}

cat("The prime factors of 600,851,475,143 are", paste(prime.factors(600851475143), collapse = ", "), "\n")

