numfmt 0 8
func calc_sqrt .
   n = 100
   sum = n
   while n >= 1
      a = 2
      if n = 1 : a = 1
      b = 1
      sum = a + b / sum
      n -= 1
   .
   return sum
.
func calc_e .
   n = 100
   sum = n
   while n >= 1
      a = n - 1
      b = n - 1
      if n = 1
         a = 2
         b = 1
      .
      sum = a + b / sum
      n -= 1
   .
   return sum
.
func calc_pi .
   n = 100
   sum = n
   while n >= 1
      a = 6
      if n = 1 : a = 3
      b = 2 * n - 1
      b *= b
      sum = a + b / sum
      n -= 1
   .
   return sum
.
print calc_sqrt
print calc_e
print calc_pi
