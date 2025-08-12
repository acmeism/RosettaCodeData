func spid s$ .
   for p$ in strchars s$
      if p$ = "Q"
         q[] &= i
      elif p$ = "K"
         k[] &= i
      elif p$ = "B"
         b[] &= i
      elif p$ = "N"
         n[] &= i
      elif p$ = "R"
         r[] &= i
      else
         print "Illegal piece: " & p$
         return 0
      .
      i += 1
   .
   if len k[] <> 1 : err$ &= "There must be exactly one King. "
   if len q[] <> 1 : err$ &= "There must be exactly one Queen. "
   if len b[] <> 2 : err$ &= "There must be exactly two Bishops. "
   if len n[] <> 2 : err$ &= "There must be exactly two Knights. "
   if len r[] <> 2 : err$ &= "There must be exactly two Rocks. "
   if k[1] < r[1] or k[1] > r[2] : err$ &= "King must be between the Rocks."
   if (b[1] - b[2]) mod 2 = 0 : err$ &= "Bishops must be on opposite colors."
   if err$ <> ""
      print err$
      return 0
   .
   for i = 1 to 2
      n = n[i]
      if n[i] > q[1] : n -= 1
      for j = 1 to 2
         if n[i] > b[j] : n -= 1
      .
      n[i] = n
   .
   n1 = 0
   n2 = 1
   for n = 0 to 9
      if n1 = n[1] and n2 = n[2] : break 1
      n2 += 1
      if n2 > 4
         n1 += 1
         n2 = n1 + 1
      .
   .
   q = q[1]
   for i = 1 to 2
      if q[1] > b[i] : q -= 1
   .
   for i = 1 to 2
      b = b[i]
      if bitand b 1 = 1 : l = b div 2
      if bitand b 1 = 0 : d = b div 2
   .
   return 96 * n + 16 * q + 4 * d + l
.
for s$ in [ "QNRBBNKR" "RNBQKBNR" "RQNBBKRN" "RNQBBKRN" ]
   print s$ & " -> " & spid s$
.
