func sameDigits n b .
   f = n mod b
   repeat
      n = n div b
      until n = 0
      if n mod b <> f : return 0
   .
   return 1
.
func isBrazilian7 n .
   # n >= 7
   if n mod 2 = 0 : return 1
   for b = 2 to n - 2
      if sameDigits n b = 1 : return 1
   .
   return 0
.
func prime n .
   if n mod 2 = 0 and n > 2 : return 0
   i = 3
   while i <= sqrt n
      if n mod i = 0 : return 0
      i += 2
   .
   return 1
.
for kind$ in [ "" "odd" "prime" ]
   print "First 20 " & kind$ & " Brazilian numbers:"
   n = 7
   cnt = 1
   while cnt <= 20
      if isBrazilian7 n = 1
         write n & " "
         cnt += 1
      .
      if kind$ = ""
         n += 1
      elif kind$ = "odd"
         n += 2
      else
         repeat
            n += 2
            until prime n = 1
         .
      .
   .
   print ""
.
