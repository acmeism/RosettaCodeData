proc pset x y c . .
   color c
   move x / 3.2 y / 3.2
   rect 0.3 0.3
.
on animate
   fr += 1
   if systime - t0 >= 1
      move 10 78
      color -2
      rect 80 20
      color -1
      move 10 80
      text fr / (systime - t0) & " fps"
      t0 = systime
      fr = 0
   .
   col[] = [ 000 999 ]
   for x = 0 to 319
      for y = 0 to 199
         pset x y col[randint 2]
      .
   .
.
