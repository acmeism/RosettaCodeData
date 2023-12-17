func dist th1 ph1 th2 ph2 .
   r = 6371
   ph1 -= ph2
   dz = sin th1 - sin th2
   dx = cos ph1 * cos th1 - cos th2
   dy = sin ph1 * cos th1
   return 2 * r * pi / 180 * asin (sqrt (dx * dx + dy * dy + dz * dz) / 2)
.
print dist 36.12 -86.67 33.94 -118.4
