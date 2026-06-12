pollards_rho <- function(number) {
  # Check if even
  if (number %% 2 == 0) return(2)

  # Get bit length
  bit_length <- floor(log2(number)) + 1

  # Generate random values
  x <- sample(0:(2^(bit_length-1)), 1)
  constant <- sample(0:(2^(bit_length-1)), 1)
  y <- x
  divisor <- 1

  while (divisor == 1) {
    x <- (x * x + constant) %% number
    y <- (y * y + constant) %% number
    y <- (y * y + constant) %% number
    divisor <- gcd(x - y, number)
  }

  return(divisor)
}

# GCD function (not in base R)
gcd <- function(a, b) {
  while (b != 0) {
    temp <- b
    b <- a %% b
    a <- temp
  }
  return(abs(a))
}

# Disable scientific notation
options(scipen = 999)

# Test cases
tests <- c(4294967213, 9759463979, 34225158206557151, 13)

for (test in tests) {
  divisor_one <- pollards_rho(test)
  divisor_two <- test %/% divisor_one
  stopifnot(test %% divisor_one == 0)
  cat(test, " = ", divisor_one, " * ", divisor_two, "\n")
}
