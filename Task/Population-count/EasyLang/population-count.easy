func popcnt x .
   while x > 0
      r += x mod 2
      x = x div 2
   .
   return r
.
proc show3 . .
   write "3^n:"
   bb = 1
   for i = 1 to 30
      write " " & popcnt bb
      bb *= 3
   .
   print ""
.
proc show s$ x . .
   write s$
   while n < 30
      if popcnt i mod 2 = x
         n += 1
         write " " & i
      .
      i += 1
   .
   print ""
.
show3
show "evil:" 0
show "odious:" 1
