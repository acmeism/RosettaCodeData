func disarium x .
   h = x
   while h > 0
      d[] &= h mod 10
      h = h div 10
   .
   for i = 1 to len d[]
      h += pow d[i] (len d[] - i + 1)
   .
   return if h = x
.
while count < 19
   if disarium n = 1
      count += 1
      print n
   .
   n += 1
.
