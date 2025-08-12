sysconf topleft
proc quadraticbezier x1 y1 x2 y2 x3 y3 nseg .
   gpenup
   for i = 0 to nseg
      t = i / nseg
      t1 = 1 - t
      a = t1 * t1
      b = 2 * t * t1
      c = t * t
      x = a * x1 + b * x2 + c * x3 + 0.5
      y = a * y1 + b * y2 + c * y3 + 0.5
      glineto x y
   .
.
glinewidth 0.5
quadraticbezier 1 1 30 37 59 1 100
