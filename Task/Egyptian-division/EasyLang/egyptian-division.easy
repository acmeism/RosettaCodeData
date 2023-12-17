proc egyptdiv a b . .
   p2 = 1
   dbl = b
   while dbl <= a
      p2s[] &= p2
      dbls[] &= dbl
      dbl *= 2
      p2 *= 2
   .
   for i = len p2s[] downto 1
      if acc + dbls[i] <= a
         acc += dbls[i]
         ans += p2s[i]
      .
   .
   print a & " / " & b & " = " & ans & " R " & abs (acc - a)
.
egyptdiv 580 34
