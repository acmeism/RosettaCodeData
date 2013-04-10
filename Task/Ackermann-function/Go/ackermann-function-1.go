func Ackermann(m, n uint) uint {
  switch {
    case m == 0:
      return n + 1
    case n == 0:
      return Ackermann(m - 1, 1)
  }
  return Ackermann(m - 1, Ackermann(m, n - 1))
}
