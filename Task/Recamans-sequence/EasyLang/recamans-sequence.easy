len seen[] 100
#
a[] &= 0
seen[1] = 1
i = 1
repeat
   h = a[i - 1 + 1] - i
   if h <= 0 or seen[h + 1] = 1
      h = a[i - 1 + 1] + i
   .
   until seen[h + 1] = 1
   seen[h + 1] = 1
   a[] &= h
   if i = 14
      print a[]
   .
   i += 1
.
print h
