func p y .
   return (y + y div 4 - y div 100 + y div 400) mod 7
.
func longyear y .
   return if p y = 4 or p (y - 1) = 3
.
for y = 2000 to 2100
   if longyear y = 1
      write y & " "
   .
.
