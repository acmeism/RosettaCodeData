iterate <- function(f, x, n, a=FALSE){
  Reduce(function(y, g) g(y), rep(list(f), n), x, accumulate=a)
}

brent <- function(f, x_0){
  pow_2 <- lam <- 1
  tortoise <- x_0
  hare <- f(x_0)
  while(tortoise!=hare){
    if(pow_2==lam){
      tortoise <- hare
      pow_2 <- 2*pow_2
      lam <- 0
    }
    hare <- f(hare)
    lam <- lam+1
  }
  mu <- 0
  tortoise <- hare <- x_0
  hare <- iterate(f, hare, lam)
  while(tortoise!=hare){
    tortoise <- f(tortoise)
    hare <- f(hare)
    mu <- mu+1
  }
  start_val <- iterate(f, x_0, mu)
  cycle_full <- iterate(f, start_val, lam-1, a=TRUE)
  cat("Cycle length:", lam, "\n")
  cat("Cycle start index:", mu, "\n")
  cat("Cycle:", cycle_full, "\n")
}

test_fun <- function(x) (x*x+1)%%255
brent(test_fun, 3)
