n = 250
len p5[] n
len h5[] 65537
for i = 0 to n - 1
   p5[i + 1] = i * i * i * i * i
   h5[p5[i + 1] mod 65537 + 1] = 1
.
fastfunc search a s .
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
len r[] 5
fastproc .
   for a = 0 to n - 1
      for b = 0 to a
         sum1 = p5[a + 1] + p5[b + 1]
         for c = 0 to b
            sum2 = p5[c + 1] + sum1
            for d = 0 to c
               sum = p5[d + 1] + sum2
               if h5[sum mod 65537 + 1] = 1
                  y = search a sum
                  if y >= 0
                     r[1] = a
                     r[2] = b
                     r[3] = c
                     r[4] = d
                     r[5] = y
                     break 4
                  .
               .
            .
         .
      .
   .
.
sus$[] = [ "⁵" "⁴" "³" "²" ]
for i to 4
   write r[i] & sus$[i]
   if i <= 3 : write " + "
.
print " = " & r[5] & sus$[1]
