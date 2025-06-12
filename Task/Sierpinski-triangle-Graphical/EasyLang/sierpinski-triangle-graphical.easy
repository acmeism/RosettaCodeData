proc triang lev x y size .
   if lev = 0
      gcircle x y 0.15
   else
      lev -= 1
      size /= 2
      triang lev x + size y size
      triang lev x + size / 2 y + size size
      triang lev x y size
   .
.
triang 8 5 5 90
