func gcd_iterative*(u, v: SomeSignedInt): int64 =
  var u = u
  var v = v
  while v != 0:
      u = u mod v
      swap u, v
  result = abs(u)

when isMainModule:
  import strformat
  let (x, y) = (49865, 69811)
  echo &"gcd({x}, {y}) = {gcd_iterative(49865, 69811)}")
