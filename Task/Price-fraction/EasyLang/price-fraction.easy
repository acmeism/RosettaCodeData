n[] = [ 10 18 26 32 38 44 50 54 58 62 66 70 74 78 82 86 90 94 98 100 ]
func conv p .
   cat = (p - 1) div 5 + 1
   return n[cat]
.
for in = 5 step 5 to 100
   if in = 100
      in$ = "1.00"
   elif in < 10
      in$ = "0.0" & in
   else
      in$ = "0." & in
   .
   out = conv in
   if out = 100
      out$ = "1.00"
   else
      out$ = "0." & out
   .
   print in$ & " -> " & out$
.
