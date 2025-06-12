proc circ x y r c .
   gcolor c
   gcircle x y r
.
proc yinyang x y r .
   circ x y 2 * r 000
   gcolor 999
   gcircseg x y 2 * r 90 -90
   circ x y - r r 000
   circ x y - r r / 3 999
   circ x y + r r 999
   circ x y + r r / 3 000
.
gbackground 555
gclear
yinyang 20 20 6
yinyang 50 60 14
