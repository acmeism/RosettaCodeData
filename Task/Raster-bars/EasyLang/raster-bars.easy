col[][] = [ [ 0.9 0.45 0.3 ] [ 0.8 0.5 0.3 ] [ 1 0.95 0.9 ] [ 1 0.85 0.4 ] ]
proc showbar y n .
   ci = n mod1 4
   h = 6 + n
   y -= h / 2
   for i = 0 step 0.5 to h
      v = i / h
      gcolor3 v * col[ci][1] v * col[ci][2] v * col[ci][3]
      grect 0 y + i 100 0.6
   .
.
gbackground 000
on animate
   gclear
   for n = 1 to 8
      phase = n * 23
      y = 40 * sin (ang + phase)
      showbar y + 50 n
   .
   ang = (ang + 2.3) mod 360
.
