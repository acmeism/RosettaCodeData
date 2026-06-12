# Function to compute binomial coefficient "n choose k"
binomial_coeff <- function(n, k) {
  if (k > n || k < 0) return(0)
  return(choose(n, k))
}

# Forward binomial transform
binomial_transform <- function(seq) {
  n <- length(seq)
  result <- numeric(n)
  for (i in 1:n) {
    result[i] <- sum(sapply(1:i, function(k) binomial_coeff(i - 1, k - 1) * seq[k]))
  }
  return(result)
}

# Inverse binomial transform
inverse_binomial_transform <- function(seq) {
  n <- length(seq)
  result <- numeric(n)
  for (i in 1:n) {
    result[i] <- sum(sapply(1:i, function(k)
      (-1)^(i - k) * binomial_coeff(i - 1, k - 1) * seq[k]))
  }
  return(result)
}

# Test sequences
test_sequences <- list(
  "Catalan number sequence" = c(
    1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862,
    16796, 58786, 208012, 742900, 2674440, 9694845,
    35357670, 129644790, 477638700, 1767263190
  ),
  "Prime flip-flop sequence" = c(
    0, 1, 1, 0, 1, 0, 1, 0, 0, 0,
    1, 0, 1, 0, 0, 0, 1, 0, 1, 0
  ),
  "Fibonacci number sequence" = c(
    0, 1, 1, 2, 3, 5, 8, 13, 21, 34,
    55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181
  ),
  "Padovan number sequence" = c(
    1, 0, 0, 1, 0, 1, 1, 1, 2, 2,
    3, 4, 5, 7, 9, 12, 16, 21, 28, 37
  )
)

# Main execution
for (desc in names(test_sequences)) {
  seq <- test_sequences[[desc]]

  cat(desc, ":\n")
  print(seq)

  forward <- binomial_transform(seq)
  cat("Forward binomial transform:\n")
  print(forward)

  inverse <- inverse_binomial_transform(seq)
  cat("Inverse binomial transform:\n")
  print(inverse)

  round_trip <- inverse_binomial_transform(binomial_transform(seq))
  cat("Round trip:\n")
  print(round_trip)

  cat("\n")
}
