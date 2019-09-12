next.perm <- function(a) {
  n <- length(a)
  i <- n
  while (i > 1 && a[i - 1] >= a[i]) i <- i - 1
  if (i == 1) {
    NULL
  } else {
    j <- i
    k <- n
    while (j < k) {
      s <- a[j]
      a[j] <- a[k]
      a[k] <- s
      j <- j + 1
      k <- k - 1
    }
    s <- a[i - 1]
    j <- i
    while (a[j] <= s) j <- j + 1
    a[i - 1] <- a[j]
    a[j] <- s
    a
  }
}

perm <- function(n) {
  e <- NULL
  a <- 1:n
  repeat {
    e <- cbind(e, a)
    a <- next.perm(a)
    if (is.null(a)) break
  }
  unname(e)
}
