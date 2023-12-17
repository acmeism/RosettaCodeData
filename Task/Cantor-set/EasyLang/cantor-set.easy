color 555
proc cantor x y sz . .
   if sz > 0.1
      sz3 = sz / 3
      move x y - sz3
      rect sz sz3
      cantor x y - sz3 sz3
      cantor x + 2 * sz3 y - sz3 sz3
   .
.
cantor 0 80 100
