func leap year .
   return if year mod 4 = 0 and (year mod 100 <> 0 or year mod 400 = 0)
.
func weekday year month day .
   normdoom[] = [ 3 7 7 4 2 6 4 1 5 3 7 5 ]
   c = year div 100
   r = year mod 100
   s = r div 12
   t = r mod 12
   c_anchor = (5 * (c mod 4) + 2) mod 7
   doom = (s + t + (t div 4) + c_anchor) mod 7
   anchor = normdoom[month]
   if leap year = 1 and month <= 2
      anchor = (anchor + 1) mod1 7
   .
   return (doom + day - anchor + 7) mod 7 + 1
.
mdays[] = [ 31 28 31 30 31 30 31 31 30 31 30 31 ]
proc last_sundays year . .
   for m to 12
      d = mdays[m]
      if m = 2 and leap year = 1
         d = 29
      .
      d -= weekday year m d - 1
      m$ = m
      if m < 10
         m$ = "0" & m
      .
      print year & "-" & m$ & "-" & d
   .
.
last_sundays 2023
