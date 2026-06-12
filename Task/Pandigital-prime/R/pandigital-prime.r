# Load permutation function
library(gtools)

# ----------- Prime Check (Efficient) -----------
is_prime <- function(n) {
  if (n < 2) return(FALSE)
  if (n == 2) return(TRUE)
  if (n %% 2 == 0) return(FALSE)

  limit <- floor(sqrt(n))
  for (i in seq(3, limit, by = 2)) {
    if (n %% i == 0) return(FALSE)
  }
  return(TRUE)
}

# ----------- Digit-Sum Primality Filter -----------
# Returns TRUE if sum of digits is NOT divisible by 3
# (Otherwise, number is divisible by 3 and can't be prime)
digit_sum_is_valid <- function(n) {
  sum_digits <- sum(as.integer(unlist(strsplit(n, ""))))
  return(sum_digits %% 3 != 0)
}

# ----------- Generate All Pandigital Permutations -----------
generate_pandigital_numbers <- function(limit) {
  pandigital_numbers <- integer(0)

  for (n in 1:9) {
    digits <- as.character(1:n)

    # Skip if digit-sum divisible by 3 (all permutations will be divisible by 3)
    if (sum(as.integer(digits)) %% 3 == 0) next

    perms <- permutations(n = n, r = n, v = digits)

    # Convert rows of digit matrices into integers efficiently
    nums <- as.integer(apply(perms, 1, paste, collapse = ""))

    # Keep only those less than the limit
    valid <- nums[nums < limit]
    pandigital_numbers <- c(pandigital_numbers, valid)
  }
  return(pandigital_numbers)
}

# ----------- Main Driver Function -----------
find_prime_pandigitals <- function(limit = 987654321) {
  pandigital_nums <- generate_pandigital_numbers(limit)

  prime_flags <- vapply(pandigital_nums, is_prime, logical(1))
  pandigital_primes <- pandigital_nums[prime_flags]

  cat("Largest prime pandigital number:", max(pandigital_primes), "\n")
}

# ----------- Run Program -----------
find_prime_pandigitals()


