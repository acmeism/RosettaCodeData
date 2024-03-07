proc circ r c . .
   color c
   circle r
.
proc yinyang x y r . .
   move x y
   circ 2 * r 000
   color 999
   circseg 2 * r 90 -90
   move x y - r
   circ r 000
   circ r / 3 999
   move x y + r
   circ r 999
   circ r / 3 000
.
background 555
clear
yinyang 20 20 6
yinyang 50 60 14
