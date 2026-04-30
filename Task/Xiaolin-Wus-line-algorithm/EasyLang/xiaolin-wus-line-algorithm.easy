size = 400
#
sc = 100 / size
global plotswap .
proc plot x y b .
   b = 1 - b
   if plotswap = 1 : swap x y
   gcolor3 b b b
   grect x * sc y * sc sc sc
.
func ipart x .
   return floor x
.
func round x .
   return floor (x + 0.5)
.
func fpart x .
   return x - floor x
.
func rfpart x .
   return 1 - x + floor x
.
proc aaLine x1 y1 x2 y2 .
   dx = x2 - x1
   dy = y2 - y1
   ax = dx
   if ax < 0 : ax = -ax
   ay = dy
   if ay < 0 : ay = -ay
   plotswap = 0
   if ax < ay
      swap x1 y1
      swap x2 y2
      swap dx dy
      plotswap = 1
   .
   if x2 < x1
      swap x1 x2
      swap y1 y2
   .
   gradient = dy / dx
   xend = round x1
   yend = y1 + gradient * (xend - x1)
   xgap = rfpart (x1 + 0.5)
   xpxl1 = xend
   ypxl1 = ipart yend
   plot xpxl1 ypxl1 rfpart yend * xgap
   plot xpxl1 (ypxl1 + 1) fpart yend * xgap
   intery = yend + gradient
   xend = round x2
   yend = y2 + gradient * (xend - x2)
   xgap = fpart (x2 + 0.5)
   xpxl2 = xend
   ypxl2 = ipart yend
   plot xpxl2 ypxl2 rfpart yend * xgap
   plot xpxl2 (ypxl2 + 1) fpart yend * xgap
   for x = xpxl1 + 1 to xpxl2 - 1
      plot x ipart intery rfpart intery
      plot x ipart intery + 1 fpart intery
      intery += gradient
   .
.
gbackground 999
gclear
#
r = size / 2
r1 = 0.15 * r
r2 = 0.95 * r
for ang = 0 step 5 to 360
   aaLine r + r1 * sin ang, r + r1 * cos ang, r + r2 * sin ang, r + r2 * cos ang
.
