# Function to calculate Jaccard similarity
J <- function(A, B) {
  intersection <- length(intersect(A, B))
  union <- length(union(A, B))

  if (union == 0) {
    return(1)
  } else {
    return(intersection / union)
  }
}

# Define test sets
A <- integer(0)  # empty set
B <- c(1, 2, 3, 4, 5)
C <- c(1, 3, 5, 7, 9)
D <- c(2, 4, 6, 8, 10)
E <- c(2, 3, 5, 7)
F <- c(8)
testsets <- list(A, B, C, D, E, F)
set_names <- c("A", "B", "C", "D", "E", "F")

# Print header
cat("Set A             Set B             J(A, B)\n")
cat(rep("-", 44), "\n", sep = "")

# Calculate and print all combinations
for (i in 1:length(testsets)) {
  for (j in 1:length(testsets)) {
    set_a <- testsets[[i]]
    set_b <- testsets[[j]]

    # Format set names for display
    name_a <- if (length(set_a) == 0) "[]" else paste(set_a, collapse = ", ")
    name_b <- if (length(set_b) == 0) "[]" else paste(set_b, collapse = ", ")

    # Pad strings to match column width
    padded_a <- format(name_a, width = 18, justify = "left")
    padded_b <- format(name_b, width = 18, justify = "left")

    # Calculate Jaccard similarity
    jaccard <- J(set_a, set_b)

    # Print result
    cat(padded_a, padded_b, jaccard, "\n")
  }
}
