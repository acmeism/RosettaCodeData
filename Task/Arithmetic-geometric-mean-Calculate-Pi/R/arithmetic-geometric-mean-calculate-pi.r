library(Rmpfr)

agm <- function(n, prec) {
  s <- mpfr(0, prec)
  a <- mpfr(1, prec)
  g <- sqrt(mpfr("0.5", prec))
  p <- as.bigz(4)
  for (i in seq(n)) {
    m <- (a + g) / 2L
    g <- sqrt(a * g)
    a <- m
    s <- s + p * (a * a - g * g)
    p <- p + p
  }
  4L * a * a / (1L - s)
}

1e6 * log(10) / log(2)
# [1] 3321928

# Compute pi to one million decimal digits:
p <- 3322000
x <- agm(20, p)

# Check
roundMpfr(x - Const("pi", p), 64)
# 1 'mpfr' number of precision  64   bits
# [1] 4.90382361286485830568e-1000016

# Save to disk
f <- file("pi.txt", "w")
writeLines(formatMpfr(x, 1e6), f)
close(f)
