library(gmp)

data.frame(n = 1:199, p = (1:199)^3 + 2) |>
  subset(isprime(p) != 0) |>
  print(row.names = FALSE)
