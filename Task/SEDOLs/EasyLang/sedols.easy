weights[] = [ 1 3 1 7 3 9 ]
func$ chksum sedol6$ .
   if len sedol6$ <> 6
      return ""
   .
   for i to 6
      c$ = substr sedol6$ 1 1
      if strpos "AEIOU" c$ <> 0
         return ""
      .
      h = strcode substr sedol6$ i 1
      if h >= 48 and h <= 57
         h -= 48
      elif h >= 65 and h <= 90
         h -= 65 - 10
      else
         return ""
      .
      sum += h * weights[i]
   .
   return strchar ((10 - (sum mod 10)) mod 10 + 48)
.
repeat
   s$ = input
   until s$ = ""
   print s$ & chksum s$
.
input_data
710889
B0YBKJ
406566
B0YBLH
228276
B0YBKL
557910
B0YBKR
585284
B0YBKT
B00030
