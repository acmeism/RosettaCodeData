func deCasteljau c0 c1 c2 t .
   s = 1 - t
   c01 = s * c0 + t * c1
   c12 = s * c1 + t * c2
   return s * c01 + t * c12
.
func xConvexLeftPar t .
   return deCasteljau 2 (-8) 2 t
.
func yConvexRightPar t .
   return deCasteljau 1 2 3 t
.
func implicitEq x y .
   return 5 * x * x + y - 5
.
func f t r .
   x = xConvexLeftPar t
   y = yConvexRightPar t
   r = implicitEq x y
   return r + t
.
func aitken p0 .
   p1 = f p0 p1
   p2 = f p1 p2
   p1m0 = p1 - p0
   return p0 - p1m0 * p1m0 / (p2 - 2 * p1 + p0)
.
func steffAitken p0 tol maxiter .
   for i to maxiter
      p = aitken p0
      if abs (p - p0) < tol : return p
      p0 = p
   .
   return number "nan"
.
for i to 11
   numfmt 0 1
   write "t0 = " & t0 & " : "
   t = steffAitken t0 0.00000001 1000
   numfmt 0 3
   if t <> t
      # nan
      print "no answer"
   else
      x = xConvexLeftPar t
      y = yConvexRightPar t
      r = implicitEq x y
      if abs r <= 0.000001
         print "intersection at (" & x & " " & y & ")"
      else
         print "spurious solution"
      .
   .
   t0 += 0.1
.
