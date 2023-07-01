gauss <- function(a, b) {
  n <- nrow(a)
  det <- 1

  for (i in seq_len(n - 1)) {
    j <- which.max(a[i:n, i]) + i - 1
    if (j != i) {
      a[c(i, j), i:n] <- a[c(j, i), i:n]
      b[c(i, j), ] <- b[c(j, i), ]
      det <- -det
    }

    k <- seq(i + 1, n)
    for (j in k) {
      s <- a[[j, i]] / a[[i, i]]
      a[j, k] <- a[j, k] - s * a[i, k]
      b[j, ] <- b[j, ] - s * b[i, ]
    }
  }

  for (i in seq(n, 1)) {
    if (i < n) {
      for (j in seq(i + 1, n)) {
        b[i, ] <- b[i, ] - a[[i, j]] * b[j, ]
      }
    }
    b[i, ] <- b[i, ] / a[[i, i]]
    det <- det * a[[i, i]]
  }

  list(x=b, det=det)
}

a <- matrix(c(2, 9, 4, 7, 5, 3, 6, 1, 8), 3, 3, byrow=T)
gauss(a, diag(3))
