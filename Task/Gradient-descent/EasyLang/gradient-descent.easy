e = 2.7182818284590452354
func sqr x .
   return x * x
.
eps = sqrt 0.0000001
numfmt 0 10
func myfun x y .
   return sqr (x - 1) * pow e -sqr y + y * (y + 2) * pow e (-2 * sqr x)
.
func xd x y .
   a = myfun (x * (1 + eps)) y
   b = myfun (x * (1 - eps)) y
   return (a - b) / (2 * x * eps)
.
func yd x y .
   a = myfun x (y * (1 + eps))
   b = myfun x (y * (1 - eps))
   return (a - b) / (2 * y * eps)
.
proc gd .
   x = 0.1
   y = -1
   for i to 31
      x -= 0.3 * xd x y
      y -= 0.3 * yd x y
   .
   print x & " " & y
.
gd
