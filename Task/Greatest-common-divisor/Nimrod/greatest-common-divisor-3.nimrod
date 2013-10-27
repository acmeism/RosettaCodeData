proc gcd_binary(u1, v1: int64): int64 =
  var t, k: int64
  var u = u1
  var v = v1
  u = abs(u)
  v = abs(v)
  if u < v:
      t = u
      u = v
      v = t
  if v == 0:
    result = u
  else:
    k = 1
    while (u %% 2 == 0) and (v %% 2 == 0):
      u = u shl 1
      v = v shl 1
      k = k shr 1
    if (u %% 2) == 0:
      t = u
    else:
      t = -v
    while t != 0:
      while (t %% 2) == 0:
        t = t div 2
      if t > 0:
        u = t
      else:
        v = -t
      t = u - v
    result = u * k

echo ("GCD(", 49865, ", ", 69811, "): ", gcd_iterative(49865, 69811), " (iterative)")
echo ("GCD(", 49865, ", ", 69811, "): ", gcd_recursive(49865, 69811), " (recursive)")
echo ("GCD(", 49865, ", ", 69811, "): ", gcd_binary   (49865, 69811), " (binary)")
