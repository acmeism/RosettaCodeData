func check inp$ .
   for i = 1 to 8
      c = strcode substr inp$ i 1
      if c >= 48 and c <= 57
         v = c - 48
      elif c >= 65 and c <= 91
         v = c - 64 + 9
      elif c = 42
         v = 36
      elif c = 64
         v = 37
      elif c = 35
         v = 38
      .
      if i mod 2 = 0
         v *= 2
      .
      sum += v div 10 + v mod 10
   .
   return if (10 - (sum mod 10)) mod 10 = number substr inp$ 9 1
.
for s$ in [ "037833100" "17275R102" "38259P508" "594918104" "68389X106" "68389X105" ]
   write s$ & " is "
   if check s$ = 1
      print "valid"
   else
      print "invalid"
   .
.
