#===============================================================
# Find k-Almost-primes
# R implementation
#===============================================================
#---------------------------------------------------------------
# Function for prime factorization from Rosetta Code
#---------------------------------------------------------------

findfactors <- function(n) {
  d <- c()
  div <- 2; nxt <- 3; rest <- n
  while( rest != 1 ) {
    while( rest%%div == 0 ) {
      d <- c(d, div)
      rest <- floor(rest / div)
    }
    div <- nxt
    nxt <- nxt + 2
  }
  d
}

#---------------------------------------------------------------
# Find k-Almost-primes
#---------------------------------------------------------------

almost_primes <- function(n = 10, k = 5) {

  # Set up matrix for storing of the results

  res <- matrix(NA, nrow = k, ncol = n)
  rownames(res) <- paste("k = ", 1:k, sep = "")
  colnames(res) <- rep("", n)

  # Loop over k

  for (i in 1:k) {

    tmp <- 1

    while (any(is.na(res[i, ]))) { # Keep looping if there are still missing entries in the result-matrix
      if (length(findfactors(tmp)) == i) { # Check number of factors
        res[i, which.max(is.na(res[i, ]))] <- tmp
      }
      tmp <- tmp + 1
    }
  }
  print(res)
}
