color 944
linewidth 0.3
on animate
   clear
   incr = (incr + 0.05) mod 360
   x1 = 50
   y1 = 50
   length = 1
   angle = incr
   move x1 y1
   for i = 1 to 150
      x2 = x1 + cos angle * length
      y2 = y1 + sin angle * length
      line x2 y2
      x1 = x2
      y1 = y2
      length += 1
      angle = (angle + incr) mod 360
   .
.
