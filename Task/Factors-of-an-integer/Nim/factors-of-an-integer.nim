import intsets, math, algorithm

proc factors(n): seq[int] =
  var fs = initIntSet()
  for x in 1 .. int(sqrt(float(n))):
    if n mod x == 0:
      fs.incl(x)
      fs.incl(n div x)

  result = @[]
  for x in fs:
    result.add(x)
  sort(result, system.cmp[int])

echo factors(45)
