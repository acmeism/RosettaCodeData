func ISBN13check isbn$ .
   for c$ in strchars isbn$
      if c$ <> "-"
         ndigs += 1
      .
      dig = number c$
      if ndigs mod 2 = 0
         dig *= 3
      .
      sum += dig
   .
   if sum mod 10 <> 0
      return 0
   .
   return 1
.
codes$[] = [ "978-0596528126" "978-0596528120" "978-1788399081" "978-1788399083" ]
for code$ in codes$[]
   if ISBN13check code$ = 1
      print code$ & " is a valid ISBN"
   else
      print code$ & " is not a valid ISBN"
   .
.
