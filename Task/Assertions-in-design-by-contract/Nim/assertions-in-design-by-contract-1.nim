import math

func isqrt(n: int): int =
  assert n >= 0, "argument of “isqrt” cannot be negative"
  int(sqrt(n.toFloat))
