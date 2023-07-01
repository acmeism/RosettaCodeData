import bignum

proc calcPi() =
  var
    q = newInt(1)
    r = newInt(0)
    t = newInt(1)
    k = newInt(1)
    n = newInt(3)
    l = newInt(3)

  var count = 0
  while true:
    if 4 * q + r - t < n * t:
      stdout.write n
      inc count
      if count == 40: (echo ""; count = 0)
      let nr = 10 * (r - n * t)
      n = 10 * (3 * q + r) div t - 10 * n
      q *= 10
      r = nr
    else:
      let nr = (2 * q + r) * l
      let nn = (7 * q * k + 2 + r * l) div (t * l)
      q *= k
      t *= l
      l += 2
      k += 1
      n = nn
      r = nr

calcPi()
