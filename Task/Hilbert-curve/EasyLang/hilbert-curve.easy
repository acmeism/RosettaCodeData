order = 64
glinewidth 32 / order
scale = 100 / order - 100 / (order * order)
proc hilbert x y lg i1 i2 .
   if lg = 1
      glineto (order - x) * scale (order - y) * scale
      return
   .
   lg = lg div 2
   hilbert x + i1 * lg y + i1 * lg lg i1 1 - i2
   hilbert x + i2 * lg y + (1 - i2) * lg lg i1 i2
   hilbert x + (1 - i1) * lg y + (1 - i1) * lg lg i1 i2
   hilbert x + (1 - i2) * lg y + i2 * lg lg 1 - i1 i2
.
hilbert 0 0 order 0 0
