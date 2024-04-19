proc verse x$ . .
   x1$ = substr x$ 1 1
   y$ = substr x$ 2 99
   if strpos "AEIOU" x1$ <> 0
      h$ = strchar (strcode x1$ + 32)
      y$ = h$ & y$
   .
   b$ = "b" & y$
   f$ = "f" & y$
   m$ = "m" & y$
   if x1$ = "B"
      b$ = y$
   elif x1$ = "F"
      f$ = y$
   elif x1$ = "M"
      m$ = y$
   .
   print x$ & ", " & x$ & ", bo-" & b$
   print "Banana-fana fo-" & f$
   print "Fee-fi-mo-" & m$
   print x$ & "!"
.
for n$ in [ "Gary" "Earl" "Billy" "Felix" "Mary" ]
   verse n$
   print ""
.
