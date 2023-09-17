proc koch x1 y1 x2 y2 iter . .
   x3 = (x1 * 2 + x2) / 3
   y3 = (y1 * 2 + y2) / 3
   x4 = (x1 + x2 * 2) / 3
   y4 = (y1 + y2 * 2) / 3
   x5 = x3 + (x4 - x3) * cos 60 + (y4 - y3) * sin 60
   y5 = y3 - (x4 - x3) * sin 60 + (y4 - y3) * cos 60
   if iter > 0
      iter -= 1
      koch x1 y1 x3 y3 iter
      koch x3 y3 x5 y5 iter
      koch x5 y5 x4 y4 iter
      koch x4 y4 x2 y2 iter
   else
      line x1 y1
      line x3 y3
      line x5 y5
      line x4 y4
      line x2 y2
   .
.
linewidth 0.3
x1 = 15
y1 = 30
move x1 y1
for ang = 0 step 120 to 240
   x2 = x1 + 70 * cos ang
   y2 = y1 + 70 * sin ang
   koch x1 y1 x2 y2 4
   x1 = x2
   y1 = y2
.
