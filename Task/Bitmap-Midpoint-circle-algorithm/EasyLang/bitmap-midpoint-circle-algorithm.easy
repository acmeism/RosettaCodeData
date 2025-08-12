proc pix x y .
   grect x / 5 y / 5 0.25 0.25
.
proc circ x0 y0 r .
   t1 = r div 16
   x = r
   while x >= y
      pix x0 - x, y0 + y
      pix x0 - x, y0 - y
      pix x0 - y, y0 + x
      pix x0 - y, y0 - x
      pix x0 + x, y0 + y
      pix x0 + x, y0 - y
      pix x0 + y, y0 + x
      pix x0 + y, y0 - x
      y += 1
      t1 += y
      t2 = t1 - x
      if t2 >= 0
         t1 = t2
         x -= 1
      .
   .
.
for r = 20 step 20 to 240
   circ 250 250 r
.
