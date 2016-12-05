proc binomialCoeff(n, k): int =
  result = 1
  for i in 1..k:
    result = result * (n-i+1) div i

echo binomialCoeff(5, 3)
