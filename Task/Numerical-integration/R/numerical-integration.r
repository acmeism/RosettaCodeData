integ <- function(f, a, b, n, u, v) {
  h <- (b - a) / n
  s <- 0
  for (i in seq(0, n - 1)) {
    s <- s + sum(v * f(a + i * h + u * h))
  }
  s * h
}

test <- function(f, a, b, n) {
  c(rect.left = integ(f, a, b, n, 0, 1),
    rect.right = integ(f, a, b, n, 1, 1),
    rect.mid = integ(f, a, b, n, 0.5, 1),
    trapezoidal = integ(f, a, b, n, c(0, 1), c(0.5, 0.5)),
    simpson = integ(f, a, b, n, c(0, 0.5, 1), c(1, 4, 1) / 6))
}

test(\(x) x^3, 0, 1, 100)
#  rect.left  rect.right    rect.mid trapezoidal     simpson
#  0.2450250   0.2550250   0.2499875   0.2500250   0.2500000

test(\(x) 1 / x, 1, 100, 1000)
#  rect.left  rect.right    rect.mid trapezoidal     simpson
#   4.654991    4.556981    4.604763    4.605986    4.605170

test(\(x) x, 0, 5000, 5e6)
#  rect.left  rect.right    rect.mid trapezoidal     simpson
#   12499998    12500003    12500000    12500000    12500000

test(\(x) x, 0, 6000, 6e6)
#  rect.left  rect.right    rect.mid trapezoidal     simpson
#    1.8e+07     1.8e+07     1.8e+07     1.8e+07     1.8e+07
