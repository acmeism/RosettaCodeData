func wkday year month day .
   adj = (14 - month) div 12
   mm = month + 12 * adj - 2
   yy = year - adj
   r = day + (13 * mm - 1) div 5 + yy + yy div 4 - yy div 100 + yy div 400
   return r mod 7 + 1
.
proc show y . .
   days[] = [ 31 28 31 30 31 30 31 31 30 31 30 31 ]
   days[2] += if y mod 4 = 0 and (y mod 100 <> 0 or y mod 400 = 0)
   for m = 1 to 12
      d = days[m]
      while wkday y m d <> 1
         d -= 1
      .
      m$ = m
      if m < 10
         m$ = 0 & m
      .
      print y & "-" & m$ & "-" & d
   .
.
show 2013
