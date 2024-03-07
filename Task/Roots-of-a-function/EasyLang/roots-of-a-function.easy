func f x .
   return x * x * x - 3 * x * x + 2 * x
.
numfmt 6 0
proc findroot start stop step . .
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
proc drawfunc start stop . .
   linewidth 0.3
   drawgrid
   x = start
   while x <= stop
      line x * 10 + 50 f x * 10 + 50
      x += 0.1
   .
.
drawfunc -1 3
findroot -1 3 pow 2 -20
print ""
findroot -1 3 1e-6
