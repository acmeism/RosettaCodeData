func f x .
   return x * x * x - 3 * x * x + 2 * x
.
numfmt 0 6
proc findroot start stop step .
   x = start
   while x <= stop
      val = f x
      if val = 0
         print x & " (exact)"
      elif sign val <> sign0 and sign0 <> 0
         print x & " (err = " & step & ")"
      .
      sign0 = sign val
      x += step
   .
.
xp = 0 / 0
yp = 0
proc lineto x y .
   x = x * 10 + 50
   y = y * 10 + 50
   if xp = xp : gline xp yp x y
   xp = x
   yp = y
.
proc drawfunc start stop .
   glinewidth 0.3
   gline 0 50 100 50
   gline 50 0 50 100
   drawgrid
   x = start
   while x <= stop
      lineto x f x
      x += 0.1
   .
.
drawfunc -1 3
findroot -1 3 pow 2 -20
print ""
findroot -1 3 1e-6
