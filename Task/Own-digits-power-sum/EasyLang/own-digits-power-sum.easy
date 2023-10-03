fastfunc next curr n limit .
   repeat
      curr += 1
      if curr = limit
         return -1
      .
      sum = 0
      tmp = curr
      repeat
         dig = tmp mod 10
         tmp = tmp div 10
         h = n
         r = 1
         while h > 0
            r *= dig
            h -= 1
         .
         sum += r
         until tmp = 0
      .
      until sum = curr
   .
   return curr
.
for n = 3 to 8
   curr = pow 10 (n - 1)
   repeat
      curr = next curr n pow 10 n
      until curr = -1
      print curr
   .
.
