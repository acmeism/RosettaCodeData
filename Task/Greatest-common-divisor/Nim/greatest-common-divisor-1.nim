func gcd_recursive*(u, v: SomeSignedInt): int64 =
    if u mod v != 0:
        result = gcd_recursive(v, u mod v)
    else:
        result = abs(v)

when isMainModule:
  import strformat
  let (x, y) = (49865, 69811)
  echo &"gcd({x}, {y}) = {gcd_recursive(49865, 69811)}"
