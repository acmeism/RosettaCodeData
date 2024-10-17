func[] mian_chowla n .
   len mc[] n
   mc[1] = 1
   is[] = [ 0 1 ]
   for i = 2 to n
      j = mc[i - 1]
      repeat
         j += 1
         mc[i] = j
         for k = 1 to i
            sum = mc[k] + j
            if sum > len is[]
               len is[] sum + 10000
            .
            if is[sum] = 1
               isnew[] = [ ]
               break 1
            .
            isnew[] &= sum
         .
         until len isnew[] > 0
      .
      for v in isnew[]
         is[v] = 1
      .
   .
   return mc[]
.
mc[] = mian_chowla 100
for i to 30
   write mc[i] & " "
.
print ""
print ""
for i = 91 to 100
   write mc[i] & " "
.
