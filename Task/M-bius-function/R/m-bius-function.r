# Moebius function

Moebius <- function(n) {
  if (n == 1)
    return(1)
  m <- 1
  f <- 2
  repeat {
    if (n %% (f * f) == 0)
      m <- 0
    else {
      if (n %% f == 0) {
        m <- -m
        n <- n %/% f
      }
      f <- f + 1
    }
    if (f > n || m == 0)
      break
  }
  return(m)
}

mb <- matrix(0, 10, 10)
for (t in 0:9)
  for (u in 1:10)
    mb[t + 1, u] <- Moebius(10 * t + u)
mb
