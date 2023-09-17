len cache[] 100000 * 7 + 6
val[] = [ 1 5 10 25 50 100 ]
func count sum kind .
   if sum = 0
      return 1
   .
   if sum < 0 or kind = 0
      return 0
   .
   chind = sum * 7 + kind
   if cache[chind] > 0
      return cache[chind]
   .
   r2 = count (sum - val[kind]) kind
   r1 = count sum (kind - 1)
   r = r1 + r2
   cache[chind] = r
   return r
.
print count 100 4
print count 10000 6
print count 100000 6
# this is not exact, since numbers
# are doubles and r > 2^53
