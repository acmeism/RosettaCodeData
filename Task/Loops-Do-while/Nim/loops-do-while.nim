template doWhile(a: expr, b: stmt): stmt =
  b
  while a:
    b

var val = 1
doWhile val mod 6 != 0:
  val += 1
  echo val
