proc addsub(x, y: int): (int, int) =
  (x + y, x - y)

var (a, b) = addsub(12, 15)
