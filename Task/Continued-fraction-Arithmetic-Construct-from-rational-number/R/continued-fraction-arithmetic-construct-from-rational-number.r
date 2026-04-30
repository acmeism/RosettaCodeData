options(scipen=9)

r2cf <- function(n1, n2){
  cat("Continued fraction representation of ", n1, "/", n2, ":\n", sep="")
  while(n2 != 0){
    int <- n1%/%n2
    rem <- n1%%n2
    cat(int, "")
    n1 <- n2
    n2 <- rem
  }
  cat("\n")
}

r2cf_unary <- function(l) invisible(lapply(l, function(v) do.call(r2cf, as.list(v))))

test_fracs <- list(c(1, 2), c(3, 1), c(23, 8), c(13, 11), c(22, 7), c(-151, 77))
r2cf_unary(test_fracs)

rat_approx <- function(x, n) c(floor(x*10^n), 10^n)

test_root2 <- lapply(4:7, function(n) rat_approx(sqrt(2), n))
r2cf_unary(test_root2)

test_nearpi <- lapply(1:8, function(n) rat_approx(22/7, n))
r2cf_unary(test_nearpi)
