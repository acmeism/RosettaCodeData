import math

proc yellowstone(n: int): seq[int] =
  assert n >= 3
  result = @[1, 2, 3]
  var present = {1, 2, 3}
  var start = 4
  while result.len < n:
    var candidate = start
    while true:
      if candidate notin present and gcd(candidate, result[^1]) == 1 and gcd(candidate, result[^2]) != 1:
        result.add candidate
        present.incl candidate
        while start in present: inc start
        break
      inc candidate

echo yellowstone(30)
