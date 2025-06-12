gcolor 944
glinewidth 0.3
on animate
   gclear
   incr = (incr + 0.05) mod 360
   x = 50
   y = 50
   length = 1
   angle = incr
   for i = 1 to 150
      xp = x
      yp = y
      x += cos angle * length
      y += sin angle * length
      gline xp yp x y
      length += 1
      angle += incr
   .
.
