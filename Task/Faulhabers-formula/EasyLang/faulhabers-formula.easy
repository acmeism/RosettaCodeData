func binomial n k .
   if n < 0 or k < 0 or n < k : return -1
   if n = 0 or k = 0 : return 1
   num = 1
   for i = k + 1 to n : num *= i
   denom = 1
   for i = 2 to n - k : denom *= i
   return num / denom
.
func gcd a b .
   if b = 0 : return a
   return gcd b (a mod b)
.
func[] frac n d .
   if d = 0 : return [ 0 0 ]
   if n = 0
      d = 1
   elif d < 0
      n = -n
      d = -d
   .
   g = abs gcd n d
   if g > 1
      n /= g
      d /= g
   .
   return [ n d ]
.
func[] neg f[] .
   return [ -f[1] f[2] ]
.
func[] sub l[] r[] .
   return frac (l[1] * r[2] - l[2] * r[1]) (r[2] * l[2])
.
func[] mult l[] r[] .
   return frac (l[1] * r[1]) (l[2] * r[2])
.
func less l[] r[] .
   return if l[1] * r[2] < r[1] * l[2]
.
proc prnt f[] .
   write f[1]
   if f[2] <> 1 : write "/" & f[2]
.
func[] bernoulli n .
   if n < 0 : return [ 0 0 ]
   for m = 1 to n + 1
      a[][] &= [ 1 m ]
      for j = m downto 2
         a[j - 1][] = mult sub a[j - 1][] a[j][] [ j - 1 1 ]
      .
   .
   if n <> 1 : return a[1][]
   return neg a[1][]
.
proc faulhaber p .
   write p & " : "
   q[] = [ 1 (p + 1) ]
   sgn = -1
   for j = 0 to p
      sgn *= -1
      coeff[] = mult mult mult q[] [ sgn 1 ] [ binomial (p + 1) j 1 ] bernoulli j
      if coeff[] <> [ 0 1 ]
         if j = 0
            if coeff[] = [ 1 1 ]
               if coeff[] = [ -1 1 ]
                  write "-"
               else
                  prnt coeff[]
               .
            .
         else
            if coeff[] = [ 1 1 ]
               write " + "
            elif coeff[] = [ -1 1 ]
               write " - "
            elif less [ 0 1 ] coeff[] = 1
               write " + "
               prnt coeff[]
            else
               write " - "
               prnt neg coeff[]
            .
         .
         pwr = p + 1 - j
         write "n"
         if pwr > 1 : write "^" & pwr
      .
   .
   print ""
.
for i = 0 to 9
   faulhaber i
.
