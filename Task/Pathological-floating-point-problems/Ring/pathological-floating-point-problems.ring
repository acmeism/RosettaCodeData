# Project : Pathological floating point problems

decimals(8)
v = list(100)
v[1] = 2
v[2] = -4
for n = 3 to 100
      v[n] = (111 - 1130 / v[n-1]) + 3000 / (v[n-1] * v[n-2])
      if n < 9 or n = 20 or n = 30 or n = 50 or n = 100
         see "n = " + n + "   " + v[n] + nl
      ok
next
