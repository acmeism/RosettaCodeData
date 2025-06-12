proc pset x y c .
   gcolor c
   grect x / 3.2 y / 3.2 0.3 0.3
.
on animate
   fr += 1
   if systime - t0 >= 1
      gcolor -2
      grect 10 78 80 20
      gcolor -1
      gtext 10 80 fr / (systime - t0) & " fps"
      t0 = systime
      fr = 0
   .
   col[] = [ 000 999 ]
   for x = 0 to 319 : for y = 0 to 199
      pset x y col[random 2]
   .
.
