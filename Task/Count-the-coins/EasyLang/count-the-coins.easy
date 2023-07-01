len cache[] 100000 * 7 + 6
val[] = [ 1 5 10 25 50 100 ]
proc count sum kind . r .
   if sum = 0
      r = 1
      break 1
   .
   if sum < 0 or kind = 0
      r = 0
      break 1
   .
   chind = sum * 7 + kind
   if cache[chind] > 0
      r = cache[chind]
      break 1
   .
   call count sum - val[kind] kind r2
   call count sum kind - 1 r1
   r = r1 + r2
   cache[chind] = r
.
call count 100 4 r
print r
call count 10000 6 r
print r
call count 100000 6 r
# this is not exact, since numbers
# are doubles and r > 2^53
print r
