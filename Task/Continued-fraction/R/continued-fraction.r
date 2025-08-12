a_sqrt2 <- function(n) ifelse(n==1, 1, 2)
b_sqrt2 <- function(n) return(1)

a_e <- function(n) ifelse(n==1, 2, n-1)
b_e <- function(n) ifelse(n==1, 1, n-1)

a_pi <- function(n) ifelse(n==1, 3, 6)
b_pi <- function(n) (2*n-1)^2

continued_fraction <- function(a, b, n){
  frac <- function(x, d) a(x)+b(x)/d
  #Only print to 17 digits due to floating-point imprecision
  print(Reduce(frac, c(1:n,1), right=TRUE), digits=17)
}

print(sqrt(2), digits=17)
continued_fraction(a_sqrt2, b_sqrt2, 100)

print(exp(1), digits=17)
continued_fraction(a_e, b_e, 100)

print(pi, digits=17)
pi_ests <- sapply(cumprod(c(100, rep(10,3))),
                  function(n) continued_fraction(a_pi, b_pi, n))
