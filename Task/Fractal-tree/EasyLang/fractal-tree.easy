color 555
proc tree x y angle depth .
   glinewidth depth * 0.4
   xn = x + cos angle * depth * 1.4 * (randomf + 0.5)
   yn = y + sin angle * depth * 1.4 * (randomf + 0.5)
   gline x y xn yn
   if depth > 1
      tree xn yn (angle - 20) (depth - 1)
      tree xn yn (angle + 20) (depth - 1)
   .
.
tree 50 10 90 10
