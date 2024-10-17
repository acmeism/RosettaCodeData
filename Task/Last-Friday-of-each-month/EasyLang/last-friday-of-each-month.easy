proc show y . .
   days[] = [ 31 28 31 30 31 30 31 31 30 31 30 31 ]
   days[2] += if y mod 4 = 0 and (y mod 100 <> 0 or y mod 400 = 0)
   w = y * 365 + (y - 1) div 4 - (y - 1) div 100 + (y - 1) div 400 + 6
   for m = 1 to 12
      w = (w + days[m]) mod 7
      m$ = m
      if m < 10
         m$ = 0 & m
      .
      h = 5
      if w < 5
         h = -2
      .
      print y & "-" & m$ & "-" & days[m] + h - w
   .
.
show 2012
