# Pfaffian and Hfaffian Calculator in R

# Define matrices for testing
matrices <- list(
  # Tiny 2 x 2 matrix
  matrix(c(0, 1, -1, 0), nrow = 2, byrow = TRUE),

  # Small 4 x 4 matrix
  matrix(c(0, 1, -1, 2,
           -1, 0, 3, -4,
           1, -3, 0, 5,
           -2, 4, -5, 0), nrow = 4, byrow = TRUE),

  # Symmetric 6 x 6 matrix
  matrix(c(1, 2, 3, 4, 5, 6,
           2, 7, 8, 9, 10, 11,
           3, 8, 12, 13, 14, 15,
           4, 9, 13, 16, 17, 18,
           5, 10, 14, 17, 19, 20,
           6, 11, 15, 18, 20, 21), nrow = 6, byrow = TRUE),

  # Larger 10 x 10 matrix
  matrix(c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
           -1, 0, 8, 7, 6, 5, 4, 3, 2, 1,
           -2, -8, 0, 1, 2, 3, 4, 5, 6, 7,
           -3, -7, -1, 0, 6, 5, 4, 3, 2, 1,
           -4, -6, -2, -6, 0, 1, 2, 3, 4, 5,
           -5, -5, -3, -5, -1, 0, 4, 3, 2, 1,
           -6, -4, -4, -4, -2, -4, 0, 1, 2, 3,
           -7, -3, -5, -3, -3, -3, -1, 0, 2, 1,
           -8, -2, -6, -2, -4, -2, -2, -2, 0, 1,
           -9, -1, -7, -1, -5, -1, -3, -1, -1, 0), nrow = 10, byrow = TRUE)
)

# Function to check if matrix is antisymmetric
is_antisymmetric <- function(matrix) {
  n <- nrow(matrix)

  # Check diagonal elements are zero
  for (i in 1:n) {
    if (matrix[i, i] != 0) {
      return(FALSE)
    }
  }

  # Check antisymmetry: A[i,j] = -A[j,i]
  for (i in 1:n) {
    for (j in (i+1):n) {
      if (j <= n && matrix[i, j] != -matrix[j, i]) {
        return(FALSE)
      }
    }
  }

  return(TRUE)
}

# Function to generate all permutations recursively
generate_permutations <- function(elements) {
  if (length(elements) <= 1) {
    return(list(elements))
  }

  perms <- list()
  for (i in 1:length(elements)) {
    first <- elements[i]
    rest <- elements[-i]
    rest_perms <- generate_permutations(rest)

    for (perm in rest_perms) {
      perms <- append(perms, list(c(first, perm)), after = length(perms))
    }
  }

  return(perms)
}

# Function to calculate sign of a permutation
calculate_sign <- function(perm) {
  sign <- 1
  n <- length(perm)

  for (i in 1:(n-1)) {
    for (j in (i+1):n) {
      if (perm[i] > perm[j]) {
        sign <- -sign
      }
    }
  }

  return(sign)
}

# Function to generate all permutations with signs
signed_permutations <- function(n) {
  if (n < 0) {
    return(list())
  }

  if (n == 0) {
    return(list(list(permutation = integer(0), sign = 1)))
  }

  # Generate all permutations of 0:n
  elements <- 0:n
  perms <- generate_permutations(elements)

  # Calculate signs for each permutation
  signed_perms <- list()

  for (i in 1:length(perms)) {
    perm <- perms[[i]]
    sign <- calculate_sign(perm)
    signed_perms[[i]] <- list(permutation = perm, sign = sign)
  }

  return(signed_perms)
}

# Function to compute Pfaffian or Hfaffian
compute_faffian <- function(matrix, type = "pfaffian") {
  n_rows <- nrow(matrix)

  # Check if matrix size is even
  if (n_rows %% 2 != 0) {
    cat("Matrix size must be even for", type, "\n")
    return(NULL)
  }

  # Check if matrix is antisymmetric (only for pfaffian)
  if (type == "pfaffian" && !is_antisymmetric(matrix)) {
    cat("The", type, "does not support non-antisymmetric matrices\n")
    return(NULL)
  }

  n <- n_rows / 2
  sum_result <- 0

  # Generate signed permutations
  signed_perms <- signed_permutations(2 * n - 1)

  for (signed_perm in signed_perms) {
    sigma <- signed_perm$permutation + 1  # Convert to 1-based indexing
    sign_value <- if (type == "pfaffian") signed_perm$sign else 1

    product <- 1
    for (i in 1:n) {
      row_idx <- sigma[2 * i - 1]
      col_idx <- sigma[2 * i]
      product <- product * matrix[row_idx, col_idx]
    }

    sum_result <- sum_result + sign_value * product
  }

  # Apply normalization
  normalization <- 1 / (factorial(n) * (2^n))
  result <- round(sum_result * normalization)

  return(result)
}

# Function to print matrix in formatted way
print_matrix <- function(matrix) {
  n_rows <- nrow(matrix)
  n_cols <- ncol(matrix)

  for (i in 1:n_rows) {
    cat("|")
    for (j in 1:(n_cols-1)) {
      cat(sprintf("%2d, ", matrix[i, j]))
    }
    cat(sprintf("%2d|\n", matrix[i, n_cols]))
  }
}

# Main execution
for (i in 1:length(matrices)) {
  matrix <- matrices[[i]]
  print_matrix(matrix)

  # Compute Pfaffian
  pfaffian_result <- compute_faffian(matrix, "pfaffian")
  if (!is.null(pfaffian_result)) {
    cat("Pfaffian:", pfaffian_result, "\n")
  }

  # Compute Hfaffian
  hfaffian_result <- compute_faffian(matrix, "hfaffian")
  if (!is.null(hfaffian_result)) {
    cat("Hfaffian:", hfaffian_result, "\n")
  }

  cat("\n")
}
