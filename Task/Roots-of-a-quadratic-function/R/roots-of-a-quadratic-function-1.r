qroots <- function(a, b, c) {
  r <- sqrt(b * b - 4 * a * c + 0i)
  if (abs(b - r) > abs(b + r)) {
    z <- (-b + r) / (2 * a)
  } else {
    z <- (-b - r) / (2 * a)
  }
  c(z, c / (z * a))
}

qroots(1, 0, 2i)
[1] -1+1i  1-1i

qroots(1, -1e9, 1)
[1] 1e+09+0i 1e-09+0i
