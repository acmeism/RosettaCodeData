lower.pascal <- function(n) {
  a <- matrix(0, n, n)
  a[, 1] <- 1
  if (n > 1) {
    for (i in 2:n) {
      j <- 2:i
      a[i, j] <- a[i - 1, j - 1] + a[i - 1, j]
    }
  }
  a
}

# Alternate version
lower.pascal.alt <- function(n) {
  a <- matrix(0, n, n)
  a[, 1] <- 1
  if (n > 1) {
    for (j in 2:n) {
      i <- j:n
      a[i, j] <- cumsum(a[i - 1, j - 1])
    }
  }
  a
}

# While it's possible to modify lower.pascal to get the upper matrix,
# here we simply transpose the lower one.
upper.pascal <- function(n) t(lower.pascal(n))

symm.pascal <- function(n) {
  a <- matrix(0, n, n)
  a[, 1] <- 1
  for (i in 2:n) {
    a[, i] <- cumsum(a[, i - 1])
  }
  a
}
