# lodev.org/cgtutor/plasma.html (last example)
func dist a b c d .
   d1 = a - c
   d2 = b - d
   return 15 * sqrt (d1 * d1 + d2 * d2)
.
on animate
   for y = 0 step 0.4 to 100
      for x = 0 step 0.4 to 100
         val = sin dist (x + time) y 50 50
         val += sin dist x y 25 25
         val += sin (dist x (y + time / 7) 75 50 * 1.2)
         val += sin dist x y 75 40
         col = (val + 4) / 16
         gcolor3 col col * 2 1 - col
         grect x y 0.5 0.5
      .
   .
   time += 1
.
