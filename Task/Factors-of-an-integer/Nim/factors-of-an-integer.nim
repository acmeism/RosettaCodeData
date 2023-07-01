import intsets, math, algorithm

proc factors(n: int): seq[int] =
  var fs: IntSet
  for x in 1 .. int(sqrt(float(n))):
    if n mod x == 0:
      fs.incl(x)
      fs.incl(n div x)

  for x in fs:
    result.add(x)
  result.sort()

echo factors(45)
