proc sort . d[] .
   len tmp[] len d[]
   sz = 1
   while sz < len d[]
      swap tmp[] d[]
      left = 1
      while left < len d[]
         # merge
         mid = left + sz - 1
         if mid > len d[]
            mid = len d[]
         .
         right = mid + sz
         if right > len d[]
            right = len d[]
         .
         l = left
         r = mid + 1
         for i = left to right
            if r > right or l <= mid and tmp[l] < tmp[r]
               d[i] = tmp[l]
               l += 1
            else
               d[i] = tmp[r]
               r += 1
            .
         .
         left += 2 * sz
      .
      sz *= 2
   .
.
data[] = [ 29 4 72 44 55 26 27 77 92 5 ]
sort data[]
print data[]
