fastfunc isprim num .
   if num mod 2 = 0
      if num = 2
         return 1
      .
      return 0
   .
   if num mod 3 = 0
      if num = 3
         return 1
      .
      return 0
   .
   i = 5
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 2
      if num mod i = 0
         return 0
      .
      i += 4
   .
   return 1
.
func gcd a b .
   if b = 0
      return a
   .
   return gcd b (a mod b)
.
func lcm a b .
   return a / gcd a b * b
.
func ipow x p .
   prod = 1
   while p > 0
      if p mod 2 = 1
         prod *= x
      .
      p = p div 2
      x *= x
   .
   return prod
.
proc getprims n . prims[] .
   prims[] = [ ]
   for i = 2 to n
      d = n / i
      m = n mod i
      if m = 0
         prims[] &= i
         cnt = 0
         while m = 0
            cnt += 1
            n = d
            d = n div i
            m = n mod i
         .
         prims[] &= cnt
      .
   .
.
func pisanoPeriod m .
   c = 1
   for i = 1 to m * m
      swap p c
      c = (p + c) mod m
      if p = 0 and c = 1
         return i
      .
   .
   return 1
.
func pisanoPrime p k .
   if isprim p = 0 or k = 0
      return 0
   .
   return ipow p (k - 1) * pisanoPeriod p
.
func pisano m .
   getprims m p[]
   for i = 1 step 2 to len p[] - 1
      pps[] &= pisanoPrime p[i] p[i + 1]
   .
   if len pps[] = 0
      return 1
   .
   if len pps[] = 1
      return pps[1]
   .
   f = pps[1]
   for i = 2 to len pps[]
      f = lcm f pps[i]
   .
   return f
.
proc main . .
   for p = 2 to 14
      pp = pisanoPrime p 2
      if pp > 0
         print "pisanoPrime(" & p & ": 2) = " & pp
      .
   .
   print ""
   for p = 2 to 179
      pp = pisanoPrime p 1
      if pp > 0
         print "pisanoPrime(" & p & ": 1) = " & pp
      .
   .
   print ""
   numfmt 0 3
   print "pisano(n) for integers 'n' from 1 to 180 are:"
   for n = 1 to 180
      write pisano (n) & " "
      if n mod 15 = 0
         print ""
      .
   .
.
main
