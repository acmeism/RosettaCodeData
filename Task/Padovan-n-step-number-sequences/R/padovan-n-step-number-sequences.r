`%^%` <- function(mat, n) Reduce(`%*%`, rep(list(mat), n))

padovanmat <- function(n) {
  id <- diag(1, n, n)
  mat <- rbind(c(0, rep(1, n-1)), id)
  cbind(mat, c(1, rep(0, n)))
}

#The initial values are now 1 followed by the first n Fibonacci numbers
fibonaccis <- function(n) {
  init <- matrix(c(1, 1, 1, 0), 2, 2)
  fib <- diag(1, 2, 2)
  out <- c()
  for (i in 1:n) {
    fib <- fib %*% init
    out[i] <- fib[1, 2]
  }
  return(out)
}

gen_init <- function(n) rev(c(1, fibonaccis(n)))

padovanlike <- function(n) function(t) {
  if (t <= n+1) {
    rev(gen_init(n))[t]
  } else {
    (padovanmat(n) %^% (t-n-1) %*% gen_init(n))[1]
  }
}

for (i in 2:8) cat("n =", i, "|", sapply(1:15, padovanlike(i)), "\n")
