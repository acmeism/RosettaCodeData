n = 250
len p5[] n
len h5[] 65537
for i = 0 to n - 1
   p5[i + 1] = i * i * i * i * i
   h5[p5[i + 1] mod 65537 + 1] = 1
.
func search a s .
   y = -1
   b = n
   while a + 1 < b
      i = (a + b) div 2
      if p5[i + 1] > s
         b = i
      elif p5[i + 1] < s
         a = i
      else
         a = b
         y = i
      .
   .
   return y
.
for x0 = 0 to n - 1
   for x1 = 0 to x0
      sum1 = p5[x0 + 1] + p5[x1 + 1]
      for x2 = 0 to x1
         sum2 = p5[x2 + 1] + sum1
         for x3 = 0 to x2
            sum = p5[x3 + 1] + sum2
            if h5[sum mod 65537 + 1] = 1
               y = search x0 sum
               if y >= 0
                  print x0 & " " & x1 & " " & x2 & " " & x3 & " " & y
                  break 4
               .
            .
         .
      .
   .
.
