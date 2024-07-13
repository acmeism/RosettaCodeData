x[] = [ 0 1 2 3 4 5 6 7 8 9 ]
y[] = [ 2.7 2.8 31.4 38.1 58.0 76.2 100.5 130.0 149.3 180.0 ]
#
clear
linewidth 0.5
move 10 97
line 10 5
line 95 5
textsize 3
n = len x[]
m = 0
for i = 1 to n
   if y[i] > m
      m = y[i]
   .
.
linewidth 0.1
sty = m div 9
for i range0 10
   move 10 5 + i * 10
   line 95 5 + i * 10
   move 2 4 + i * 10
   text i * sty
.
stx = x[n] div 9
for i range0 10
   move i * 9 + 10 5
   line i * 9 + 10 97
   move i * 9 + 10 1
   text i * stx
.
color 900
linewidth 0.5
for i = 1 to n
   x = x[i] * 9 / stx + 10
   y = y[i] / sty * 10 + 5
   line x y
.
