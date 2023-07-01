import tables
import bignum

var cache: Table[(Natural, Natural), Int]

proc s1(n, k: Natural): Int =
  if k == 0: return newInt(ord(n == 0))
  if k > n: return newInt(0)
  if (n, k) in cache: return cache[(n, k)]
  result = s1(n - 1, k - 1) + (n - 1) * s1(n - 1, k)
  cache[(n, k)] = result

var max = newInt(-1)
for k in 0..100:
  let s = s1(100, k)
  if s > max: max = s
  else: break

echo "Maximum Stirling number of the first kind with n = 100:"
echo max
