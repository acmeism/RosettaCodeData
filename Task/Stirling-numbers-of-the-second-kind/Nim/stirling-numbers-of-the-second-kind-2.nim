import tables
import bignum

var cache: Table[(Natural, Natural), Int]

proc s2(n, k: Natural): Int =
  if n == k: return newInt(1)
  if n == 0 or k == 0: return newInt(0)
  if (n, k) in cache: return cache[(n, k)]
  result = k * s2(n - 1, k) + s2(n - 1, k - 1)
  cache[(n, k)] = result

var max = newInt(-1)
for k in 0..100:
  let s = s2(100, k)
  if s > max: max = s
  else: break

echo "Maximum Stirling number of the second kind with n = 100:"
echo max
