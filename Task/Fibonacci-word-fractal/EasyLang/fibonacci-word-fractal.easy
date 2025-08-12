n = 18
f1$ = "1"
f2$ = "0"
#
for i to n
   f3$ = f2$ & f1$
   f1$ = f2$
   f2$ = f3$
.
dir[][] = [ [ 1 0 ] [ 0 -1 ] [ -1 0 ] [ 0 1 ] ]
x = 5
y = 20
d = 1
a$[] = strchars f3$
glinewidth 0.3
for i to len a$[]
   glineto x y
   if a$[i] = "0"
      h = i mod 2 * 2 + 1
      d = (d + h) mod1 4
   .
   x += 0.38 * dir[d][1]
   y += 0.38 * dir[d][2]
.
