func power x n .
   r = 1
   for i = 1 to n
      r *= x
   .
   return r
.
func nth_root x n .
   r = 2
   repeat
      p = power r (n - 1)
      d = (x / p - r) / n
      r += d
      until abs d < 0.0001
   .
   return r
.
numfmt 4 0
x = power 3.1416 10
print nth_root x 10
