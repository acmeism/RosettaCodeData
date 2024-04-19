func$ to n b .
   digs$ = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
   if n = 0
      return 0
   .
   s$ = ""
   while n > 0
      idx = n mod b + 1
      n = n div b
      s$ = substr digs$ idx 1 & s$
   .
   return s$
.
func uabs a b .
   if a > b
      return a - b
   .
   return b - a
.
func isEsthetic n b .
   if n = 0
      return 0
   .
   i = n mod b
   n = n div b
   while n > 0
      j = n mod b
      if uabs i j <> 1
         return 0
      .
      n = n div b
      i = j
   .
   return 1
.
for b = 2 to 16
   print "Base " & b & ": " & 4 * b & "th to " & 6 * b & "th esthetic numbers:"
   n = 1
   c = 0
   while c < 6 * b
      if isEsthetic n b = 1
         c += 1
         if c >= 4 * b
            write to n b & " "
         .
      .
      n += 1
   .
   print ""
   print ""
.
print "Base 10 esthetic numbers between 1000 and 9999:"
for i = 1000 to 9999
   if isEsthetic i 10 = 1
      write i & " "
   .
.
