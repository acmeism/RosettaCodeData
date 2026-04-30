gaussjordan <- function(A) {
  # Check if matrix is square
  if (nrow(A) != ncol(A)) {
    stop("A must be a square matrix")
  }

  n <- nrow(A)

  # Create augmented matrix [A | I]
  M <- cbind(matrix(as.numeric(A), nrow = n, ncol = n), diag(n))

  tmp <- numeric(2 * n)
  i <- 1

  # Forward elimination
  while (i <= n) {
    # Check if pivot is approximately zero
    if (abs(M[i, i]) < 1e-10) {
      j <- i + 1
      # Find non-zero pivot
      while (j <= n && abs(M[j, i]) < 1e-10) {
        j <- j + 1
      }
      if (j <= n) {
        # Swap rows
        tmp <- M[i, ]
        M[i, ] <- M[j, ]
        M[j, ] <- tmp
      } else {
        stop("Matrix is singular, cannot compute the inverse")
      }
    }

    # Eliminate below pivot
    if (i < n) {
      for (j in (i + 1):n) {
        M[j, ] <- M[j, ] - (M[j, i] / M[i, i]) * M[i, ]
      }
    }
    i <- i + 1
  }

  i <- n

  # Backward elimination
  while (i >= 1) {
    # Check if pivot is approximately zero
    if (abs(M[i, i]) < 1e-10) {
      j <- i - 1
      # Find non-zero pivot
      while (j >= 1 && abs(M[j, i]) < 1e-10) {
        j <- j - 1
      }
      if (j >= 1) {
        # Swap rows
        tmp <- M[i, ]
        M[i, ] <- M[j, ]
        M[j, ] <- tmp
      } else {
        stop("Matrix is singular, cannot compute the inverse")
      }
    }

    # Eliminate above pivot
    if (i > 1) {
      for (j in (i - 1):1) {
        M[j, ] <- M[j, ] - (M[j, i] / M[i, i]) * M[i, ]
      }
    }
    i <- i - 1
  }

  # Normalize by diagonal elements
  M <- M / diag(M)

  # Return the inverse (right half of augmented matrix)
  return(M[, (n + 1):(2 * n)])
}

# Test examples
# Example 1: Create a test matrix
A <- matrix(c(4, 3, 2, 1), nrow = 2, ncol = 2)
print(gaussjordan(A))
print(solve(A))  # R's built-in inverse function

# Example 2: Random matrix test
set.seed(123)
A <- matrix(runif(100), nrow = 10, ncol = 10)
result <- gaussjordan(A)
expected <- solve(A)
print(all.equal(result, expected))  # Should return TRUE
