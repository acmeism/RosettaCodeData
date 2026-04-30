# ---------------------------------------------------------------
#  Strassen matrix multiplication – R version (Corrected)
# ---------------------------------------------------------------

# Helper function to pad matrix to next power of 2
pad_to_power_of_2 <- function(mat) {
  n <- nrow(mat)
  m <- ncol(mat)
  max_dim <- max(n, m)
  new_dim <- 2^ceiling(log2(max_dim))

  if (new_dim == n && new_dim == m) {
    return(mat)
  }

  padded <- matrix(0, nrow = new_dim, ncol = new_dim)
  padded[1:n, 1:m] <- mat
  return(padded)
}

# Helper to split a matrix into quadrants
split_matrix <- function(X) {
  n <- nrow(X)
  mid <- n %/% 2

  list(
    X11 = X[1:mid, 1:mid, drop = FALSE],
    X12 = X[1:mid, (mid + 1):n, drop = FALSE],
    X21 = X[(mid + 1):n, 1:mid, drop = FALSE],
    X22 = X[(mid + 1):n, (mid + 1):n, drop = FALSE]
  )
}

# Join four submatrices into one matrix
join_matrices <- function(C11, C12, C21, C22) {
  top <- cbind(C11, C12)
  bottom <- cbind(C21, C22)
  rbind(top, bottom)
}

# Strassen Matrix Multiplication
strassen <- function(A, B) {
  # Check if matrices are conformable for multiplication
  if (ncol(A) != nrow(B)) {
    stop("Matrices cannot be multiplied: incompatible dimensions")
  }

  # Pad matrices to make them square and powers of 2
  orig_rows <- nrow(A)
  orig_cols <- ncol(B)

  max_dim <- max(nrow(A), ncol(A), nrow(B), ncol(B))
  padded_dim <- 2^ceiling(log2(max_dim))

  if (nrow(A) != padded_dim || ncol(A) != padded_dim) {
    A_padded <- matrix(0, nrow = padded_dim, ncol = padded_dim)
    A_padded[1:nrow(A), 1:ncol(A)] <- A
    A <- A_padded
  }

  if (nrow(B) != padded_dim || ncol(B) != padded_dim) {
    B_padded <- matrix(0, nrow = padded_dim, ncol = padded_dim)
    B_padded[1:nrow(B), 1:ncol(B)] <- B
    B <- B_padded
  }

  # Recursive helper function
  strassen_recursive <- function(X, Y) {
    n <- nrow(X)

    # Base case: 1x1 matrix
    if (n == 1) {
      return(matrix(X[1, 1] * Y[1, 1], nrow = 1, ncol = 1))
    }

    # Split matrices into quadrants
    X_parts <- split_matrix(X)
    Y_parts <- split_matrix(Y)

    x11 <- X_parts$X11
    x12 <- X_parts$X12
    x21 <- X_parts$X21
    x22 <- X_parts$X22

    y11 <- Y_parts$X11
    y12 <- Y_parts$X12
    y21 <- Y_parts$X21
    y22 <- Y_parts$X22

    # Compute the seven products recursively
    p1 <- strassen_recursive(x12 - x22, y21 + y22)
    p2 <- strassen_recursive(x11 + x22, y11 + y22)
    p3 <- strassen_recursive(x11 - x21, y11 + y12)
    p4 <- strassen_recursive(x11 + x12, y22)
    p5 <- strassen_recursive(x11, y12 - y22)
    p6 <- strassen_recursive(x22, y21 - y11)
    p7 <- strassen_recursive(x21 + x22, y11)

    # Combine results into quadrants
    c11 <- p1 + p2 - p4 + p6
    c12 <- p4 + p5
    c21 <- p6 + p7
    c22 <- p2 - p3 + p5 - p7

    # Join and return final matrix
    join_matrices(c11, c12, c21, c22)
  }

  # Perform Strassen multiplication
  result_padded <- strassen_recursive(A, B)

  # Extract the relevant portion
  result <- result_padded[1:orig_rows, 1:orig_cols, drop = FALSE]

  return(result)
}

# ---------------------------------------------------------------
#  Helper that mimics the Julia `intprint`
# ---------------------------------------------------------------
int_print <- function(title, mat) {
  # Round to 8 decimal places and convert near-integers to integers
  rounded_mat <- round(mat, digits = 8)
  cat(title, "\n")
  print(rounded_mat)
  cat("\n")
}

# ---------------------------------------------------------------
#  Test data
# ---------------------------------------------------------------
varA <- matrix(c(1, 2, 3, 4), nrow = 2, byrow = TRUE)
varB <- matrix(c(5, 6, 7, 8), nrow = 2, byrow = TRUE)

varC <- matrix(c(
  1, 1, 1, 1,
  2, 4, 8, 16,
  3, 9, 27, 81,
  4, 16, 64, 256
), nrow = 4, byrow = TRUE)

varD <- matrix(c(
  4, -3, 4/3, -1/4,
  -13/3, 19/4, -7/3, 11/24,
  3/2, -2, 7/6, -1/4,
  -1/6, 1/4, -1/6, 1/24
), nrow = 4, byrow = TRUE)

varE <- matrix(c(
  1, 2, 3, 4,
  5, 6, 7, 8,
  9, 10, 11, 12,
  13, 14, 15, 16
), nrow = 4, byrow = TRUE)

varF <- diag(4)

r <- sqrt(2)/2
R <- matrix(c(r, r, -r, r), nrow = 2, byrow = TRUE)

# ---------------------------------------------------------------
#  Run the examples – compare ordinary (%*%) and Strassen results
# ---------------------------------------------------------------

# Example 1
int_print("Regular multiply:", t(varA) %*% t(varB))
int_print("Strassen multiply:", strassen(t(varA), t(varB)))

# Example 2
int_print("Regular multiply:", varC %*% varD)
int_print("Strassen multiply:", strassen(varC, varD))

# Example 3
int_print("Regular multiply:", varE %*% varF)
int_print("Strassen multiply:", strassen(varE, varF))

# Example 4
int_print("Regular multiply:", R %*% R)
int_print("Strassen multiply:", strassen(R, R))
