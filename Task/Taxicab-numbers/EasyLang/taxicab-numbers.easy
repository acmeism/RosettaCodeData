fastfunc taxi n m .
   repeat
      m += 1
      m3 = m * m * m
      until m3 >= n / 2
      p = m
      repeat
         p += 1
         h = m3 + p * p * p
         if h = n
            return m
         .
         until h >= n
      .
   .
   return 0
.
func part2 n m .
   return floor (0.5 + pow (n - m * m * m) (1 / 3))
.
repeat
   n += 1
   t1 = taxi n 0
   if t1 > 0
      t2 = taxi n t1
      if t2 > 0
         cnt += 1
         write n & " = "
         write t1 & "³ + " & part2 n t1 & "³ = "
         print t2 & "³ + " & part2 n t2 & "³"
      .
   .
   until cnt = 25
.
