x = 10
y = 60
glinewidth 2
while angle < 720
   xp = x
   yp = y
   x += cos angle * 80
   y += sin -angle * 80
   gline xp yp x y
   f[] &= x
   f[] &= y
   angle += 144
.
gcolor 900
gpolygon f[]
