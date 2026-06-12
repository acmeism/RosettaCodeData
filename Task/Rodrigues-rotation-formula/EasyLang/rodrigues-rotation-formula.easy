func norm v[] .
   return sqrt (v[1] * v[1] + v[2] * v[2] + v[3] * v[3])
.
func[] normalized v[] .
   l = norm v[]
   return [ v[1] / l v[2] / l v[3] / l ]
.
func dotprod v1[] v2[] .
   return v1[1] * v2[1] + v1[2] * v2[2] + v1[3] * v2[3]
.
func[] crossprod v1[] v2[] .
   return [ v1[2] * v2[3] - v1[3] * v2[2], v1[3] * v2[1] - v1[1] * v2[3], v1[1] * v2[2] - v1[2] * v2[1] ]
.
func angle v1[] v2[] .
   return acos (dotprod v1[] v2[] / (norm v1[] * norm v2[]))
.
func[] mmul m[][] v[] .
   return [ dotprod m[1][] v[], dotprod m[2][] v[], dotprod m[3][] v[] ]
.
func[] rotate p[] v[] a .
   ca = cos a
   sa = sin a
   t = 1 - ca
   x = v[1]
   y = v[2]
   z = v[3]
   r[][] &= [ ca + x * x * t, x * y * t - z * sa, x * z * t + y * sa ]
   r[][] &= [ x * y * t + z * sa, ca + y * y * t, y * z * t - x * sa ]
   r[][] &= [ z * x * t - y * sa, z * y * t + x * sa, ca + z * z * t ]
   return mmul r[][] p[]
.
proc main .
   v1[] = [ 5 -6 4 ]
   v2[] = [ 8 5 -30 ]
   a = angle v1[] v2[]
   ncp[] = normalized crossprod v1[] v2[]
   np[] = rotate v1[] ncp[] a
   print np[]
.
main
