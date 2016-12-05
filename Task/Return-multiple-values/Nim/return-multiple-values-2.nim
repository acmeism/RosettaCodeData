proc addsub(x, y: int, a, b: var int) =
  a = x + y
  b = x - y

var a, b: int
addsub(12, 15, a, b)
