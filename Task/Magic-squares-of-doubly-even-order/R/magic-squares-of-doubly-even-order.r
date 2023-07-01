magic <- function(n) {
  if (n %% 2 == 1) {
    p <- (n + 1) %/% 2 - 2
    ii <- seq(n)
    outer(ii, ii, function(i, j) n * ((i + j + p) %% n) + (i + 2 * (j - 1)) %% n + 1)
  } else if (n %% 4 == 0) {
    p <- n * (n + 1) + 1
    ii <- seq(n)
    outer(ii, ii, function(i, j) ifelse((i %/% 2 - j %/% 2) %% 2 == 0, p - n * i - j, n * (i - 1) + j))
  } else {
    p <- n %/% 2
    q <- p * p
    k <- (n - 2) %/% 4 + 1
    a <- Recall(p)
    a <- rbind(cbind(a, a + 2 * q), cbind(a + 3 * q, a + q))
    ii <- seq(p)
    jj <- c(seq(k - 1), seq(length.out=k - 2, to=n))
    m <- a[ii, jj]; a[ii, jj] <- a[ii + p, jj]; a[ii + p, jj] <- m
    jj <- c(1, k)
    m <- a[k, jj]; a[k, jj] <- a[k + p, jj]; a[k + p, jj] <- m
    a
  }
}
