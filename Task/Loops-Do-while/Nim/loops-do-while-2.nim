template doWhile(a, b: untyped): untyped =
  b
  while a:
    b

var val = 0
doWhile val mod 6 != 0:
  inc val
  echo val
