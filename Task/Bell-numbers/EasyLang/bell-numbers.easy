func bell n .
   len list[] n
   list[1] = 1
   for i = 2 to n
      for j = 1 to i - 2
         list[i - j - 1] += list[i - j]
      .
      list[i] = list[1] + list[i - 1]
   .
   return list[n]
.
for i = 1 to 15
   print bell i
.
