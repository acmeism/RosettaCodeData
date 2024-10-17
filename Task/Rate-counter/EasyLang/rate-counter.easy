color 700
d = 0.2
t0 = systime
on animate
   clear
   rad += d
   move 50 50
   circle rad
   if rad > 50 or rad < 0
      d = -d
   .
   t = systime
   print 1000 * (t - t0) & " ms"
   t0 = t
.
