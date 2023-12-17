proc pset x y . .
   move x / 4 y / 4
   rect 0.25 0.25
.
proc drawline x0 y0 x1 y1 . .
   dx = abs (x1 - x0)
   sx = -1
   if x0 < x1
      sx = 1
   .
   dy = abs (y1 - y0)
   sy = -1
   if y0 < y1
      sy = 1
   .
   err = -dy div 2
   if dx > dy
      err = dx div 2
   .
   repeat
      pset x0 y0
      until x0 = x1 and y0 = y1
      e2 = err
      if e2 > -dx
         err -= dy
         x0 += sx
      .
      if e2 < dy
         err += dx
         y0 += sy
      .
   .
.
drawline 200 10 100 200
drawline 100 200 200 390
drawline 200 390 300 200
drawline 300 200 200 10
