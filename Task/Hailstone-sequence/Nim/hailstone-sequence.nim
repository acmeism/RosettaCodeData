proc hailstone(n: int): seq[int] =
  result = @[n]
  var n = n
  while n > 1:
    if (n and 1) == 1:
      n = 3 * n + 1
    else:
      n = n div 2
    result.add n


when isMainModule:
  import strformat, strutils
  let h = hailstone(27)
  echo &"Hailstone sequence for number 27 has {h.len} elements."
  let first = h[0..3].join(", ")
  let last = h[^4..^1].join(", ")
  echo &"This sequence begins with {first} and ends with {last}."

  var m, mi = 0
  for i in 1..<100_000:
    let n = hailstone(i).len
    if n > m:
      m = n
      mi = i
  echo &"\nFor numbers < 100_000, maximum length {m} was found for Hailstone({mi})."
