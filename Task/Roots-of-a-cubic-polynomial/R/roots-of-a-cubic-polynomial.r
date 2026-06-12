horner <- function(x, coeffs) Reduce(function(a, b) a*x+b, coeffs)
tr <- function(mat) sum(diag(mat))
char_cubic <- function(mat) c(1, -tr(mat), (tr(mat)^2 - tr(mat %*% mat))/2, -det(mat))

sin45 <- 1/sqrt(2)
test_vectors <- list(c(1, -1, 0, 0, 1, 1, 0, 0, 1),
                     c(-2, -4, 2, -2, 1, 2, 4, 2, 5),
                     c(1, -1, 0, 0, 1, -1, 0, 0, 1),
                     c(2, 0, 0, 0, -1, 0, 0, 0, -1),
                     c(2, 0, 0, 0, 3, 4, 0, 4, 9),
                     c(1, 0, 0, 0, sin45, -sin45, 0, sin45, sin45))

test_matrices <- lapply(test_vectors,
                        function(v) matrix(v, nrow = 3, ncol = 3, byrow = TRUE))

for (mat in test_matrices) {
  print(mat)
  poly3 <- char_cubic(mat)
  polystring <- paste0("+ ", poly3, "*x^", 3:0)
  polystring <- gsub("+ -", "- ", polystring, fixed = TRUE)
  polystring <- gsub("\\+ 1\\*|\\*x\\^0|\\^1", "", polystring)
  cat("\nCharacteristic polynomial:", polystring, "\n")
  eigs <- eigen(mat)$values
  cat("Eigenvalues:", eigs, "\n")
  cat("Errors:", horner(eigs, poly3), "\n\n")
}
