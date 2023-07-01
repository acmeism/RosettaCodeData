mul_inv <- function(a, b)
{
  b0 <- b
  x0 <- 0L
  x1 <- 1L

  if (b == 1) return(1L)
  while(a > 1){
    q <- as.integer(a/b)

    t <- b
    b <- a %% b
    a <- t

    t <- x0
    x0 <- x1 - q*x0
    x1 <- t
  }

  if (x1 < 0) x1 <- x1 + b0
  return(x1)
}

chinese_remainder <- function(n, a)
{
  len <- length(n)

  prod <- 1L
  sum <- 0L

  for (i in 1:len) prod <- prod * n[i]

  for (i in 1:len){
    p <- as.integer(prod / n[i])
    sum <- sum + a[i] * mul_inv(p, n[i]) * p
  }

  return(sum %% prod)
}

n <- c(3L, 5L, 7L)
a <- c(2L, 3L, 2L)

chinese_remainder(n, a)
