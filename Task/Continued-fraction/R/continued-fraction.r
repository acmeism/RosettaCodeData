#Only print to 17 digits due to floating-point imprecision
options(digits = 17)

ab_sqrt2 <- function(n) c(ifelse(n == 1, 1, 2), 1)
ab_e <- function(n) c(ifelse(n == 1, 2, n-1), ifelse(n == 1, 1, n-1))
ab_pi <- function(n) c(ifelse(n == 1, 3, 6), (2*n - 1)^2)

continued_fraction <- function(f) function(n) {
  frac <- function(x, d) sum(f(x) / c(1, d))
  Reduce(frac, seq_len(n), 1, right = TRUE)
}

cat(
  "Square root of 2:", sqrt(2),
  "Estimate (n = 100):", continued_fraction(ab_sqrt2)(100),
  "\ne:", exp(1),
  "Estimate (n = 100):", continued_fraction(ab_e)(100),
  "\nPi:", pi,
  "Estimates (n = 100 to 100,000):",
  sapply(cumprod(c(100, rep(10, 3))), continued_fraction(ab_pi)),
  sep = "\n"
)
