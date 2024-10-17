func average n reps .
   for r to reps
      f[] = [ ]
      for i to n
         f[] &= random n
      .
      seen[] = [ ]
      len seen[] n
      x = 1
      while seen[x] = 0
         seen[x] = 1
         x = f[x]
         count += 1
      .
   .
   return count / reps
.
func analytical n .
   s = 1
   t = 1
   for i = n - 1 downto 1
      t = t * i / n
      s += t
   .
   return s
.
print " N  average analytical (error)"
print "=== ======= ========== ======="
for n to 20
   avg = average n 1e6
   ana = analytical n
   err = (avg - ana) / ana * 100
   numfmt 0 2
   write n
   numfmt 4 9
   print avg & ana & err & "%"
.
