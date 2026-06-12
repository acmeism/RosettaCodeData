sysconf radians
func[] vmul v[] a .
   return [ v[1] * a v[2] * a v[3] * a ]
.
func[] vadd a[] b[] .
   return [ a[1] + b[1] a[2] + b[2] a[3] + b[3] ]
.
func[] vnorm v[] .
   lng = sqrt (v[1] * v[1] + v[2] * v[2] + v[3] * v[3])
   return [ v[1] / lng v[2] / lng v[3] / lng ]
.
func[] mulAdd v1[] x1 v2[] x2 .
   return vadd vmul v1[] x1 vmul v2[] x2
.
func[][] rotate i[] j[] alpha .
   r[][] &= mulAdd i[] cos alpha j[] sin alpha
   r[][] &= mulAdd i[] -sin alpha j[] cos alpha
   return r[][]
.
func[][] orbStateVectors semimajorAxis eccentricity inclination longOfAscNode argOfPeriapsis trueAnomaly .
   i[] = [ 1 0 0 ]
   j[] = [ 0 1 0 ]
   k[] = [ 0 0 1 ]
   p[][] = rotate i[] j[] longOfAscNode
   i[] = p[1][]
   j[] = p[2][]
   p[][] = rotate j[] k[] inclination
   j[] = p[1][]
   p[][] = rotate i[] j[] argOfPeriapsis
   i[] = p[1][]
   j[] = p[2][]
   l = 2
   if eccentricity <> 1
      l = 1 - eccentricity * eccentricity
   .
   l *= semimajorAxis
   c = cos trueAnomaly
   s = sin trueAnomaly
   r = 1 / (1 + eccentricity * c)
   rprime = s * r * r / l
   position[] = vmul mulAdd i[] c j[] s r
   speed[] = mulAdd i[] (rprime * c - r * s) j[] (rprime * s + r * c)
   speed[] = vmul vnorm speed[] sqrt (2 / r - 1 / semimajorAxis)
   return [ position[] speed[] ]
.
ps[][] = orbStateVectors 1 0.1 0 (355 / (113 * 6)) 0 0
print "Position: " & ps[1][]
print "Speed:    " & ps[2][]
