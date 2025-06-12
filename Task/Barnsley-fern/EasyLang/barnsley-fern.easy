gcolor 060
for i = 1 to 200000
   r = randomf
   if r < 0.01
      nx = 0
      ny = 0.16 * y
   elif r < 0.08
      nx = 0.2 * x - 0.26 * y
      ny = 0.23 * x + 0.22 * y + 1.6
   elif r < 0.15
      nx = -0.15 * x + 0.28 * y
      ny = 0.26 * x + 0.24 * y + 0.44
   else
      nx = 0.85 * x + 0.04 * y
      ny = -0.04 * x + 0.85 * y + 1.6
   .
   x = nx
   y = ny
   grect 50 + x * 15 y * 10 0.3 0.3
.
