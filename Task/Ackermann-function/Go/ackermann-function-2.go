func Ackermann2(m, n uint) uint {
  switch {
    case m == 0:
      return n + 1
    case m == 1:
      return n + 2
    case m == 2:
      return 2*n + 3
    case m == 3:
      return 8 << n - 3
    case n == 0:
      return Ackermann2(m - 1, 1)
  }
  return Ackermann2(m - 1, Ackermann2(m, n - 1))
}
