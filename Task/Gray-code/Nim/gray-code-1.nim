proc grayEncode(n: int): int =
  n xor (n shr 1)

proc grayDecode(n: int): int =
  result = n
  var t = n
  while t > 0:
    t = t shr 1
    result = result xor t
