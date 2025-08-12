func vdot a[] b[] .
   for i to len a[] : r += a[i] * b[i]
   return r
.
func[] norm v[] .
   d = vdot v[] v[]
   invl = 1 / sqrt d
   for i to 3 : r[] &= v[i] * invl
   return r[]
.
proc sphere r k amb dir[] .
   for x = -r to r : for y = -r to r
      z = r * r - x * x - y * y
      if z >= 0
         s = vdot dir[] norm [ x y sqrt z ]
         if s < 0 : s = 0
         lum = 100 * (pow s k + amb) / (1 + amb)
         gcolor3 lum lum lum
         grect 50 + x / 5, 50 + y / 5, 0.3 0.3
      .
   .
.
gbackground 000
gclear
sphere 200 1.5 0.2 norm [ -30 30 50 ]
