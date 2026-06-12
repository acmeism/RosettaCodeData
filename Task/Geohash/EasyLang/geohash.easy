ch32$ = "0123456789bcdefghjkmnpqrstuvwxyz"
proc bisect val &mn &mx &bits .
   mid = (mn + mx) / 2
   bits *= 2
   if val < mid
      mx = mid
   else
      bits += 1
      mn = mid
   .
.
func$ encode lat lng pre .
   latmin = -90
   latmax = 90
   lngmin = -180
   lngmax = 180
   for k range0 pre
      bits = 0
      for i range0 5
         if (i + k) mod 2 = 1
            bisect lat latmin latmax bits
         else
            bisect lng lngmin lngmax bits
         .
      .
      h$ &= substr ch32$ (bits + 1) 1
   .
   return h$
.
func[][] decode geo$ .
   latlong = 2
   r[][] = [ [ -90 90 ] [ -180 180 ] ]
   for c$ in strchars geo$
      bits = strpos ch32$ c$ - 1
      mask = 16
      while mask > 0
         if bits >= mask
            bits -= mask
            b = 1
         else
            b = 2
         .
         mask = mask div 2
         sum = (r[latlong][1] + r[latlong][2]) / 2
         r[latlong][b] = sum
         latlong = 3 - latlong
      .
   .
   return r[][]
.
numfmt 0 4
hash$ = encode 51.433718 -0.214126 8
print hash$
print decode hash$
