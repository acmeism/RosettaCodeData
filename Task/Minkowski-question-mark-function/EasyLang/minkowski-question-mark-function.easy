func minkowski x .
   if x > 1 or x < 0 : return floor x + minkowski (x - floor x)
   p = floor x
   q = 1
   r = p + 1
   s = 1
   d = 1
   y = p
   while 1 = 1
      d = d / 2
      if y + d = y : break 1
      m = p + r
      if m < 0 or p < 0 : break 1
      n = q + s
      if n < 0 : break 1
      if x < m / n
         r = m
         s = n
      else
         y = y + d
         p = m
         q = n
      .
   .
   return y + d
.
Maxiter = 151
func minkowski_inv x .
   if x > 1 or x < 0 : return floor x + minkowski_inv (x - floor x)
   if x = 1 or x = 0 : return x
   curr = 0
   count = 1
   contfrac[] &= 0
   while 1 = 1
      x *= 2
      if curr = 0
         if x < 1
            count += 1
         else
            i += 1
            contfrac[] &= 0
            contfrac[i] = count
            count = 1
            curr = 1
            x -= 1
         .
      else
         if x > 1
            count += 1
            x -= 1
         else
            i += 1
            contfrac[] &= 0
            contfrac[i] = count
            count = 1
            curr = 0
            if x = floor x
               contfrac[i + 1] = count
               break 1
            .
            if i = Maxiter : break 1
         .
      .
   .
   ret = 1 / contfrac[i + 1]
   for j = i downto 1 : ret = contfrac[j] + 1 / ret
   return 1 / ret
.
numfmt 0 16
print minkowski (0.5 * (1 + sqrt 5)) & " " & 5 / 3
print minkowski_inv (-5 / 9) & " " & (sqrt 13 - 7) / 6
print minkowski minkowski_inv 0.718281828 & " " & minkowski_inv minkowski 0.1213141516171819
