n = 15
offs = 10 / n
r = (100 / (3 * n + 1))
step = 360 * 2 / (n - 1)
#
gbackground 470
gclear
for row = 0 to n - 1
   for col = 0 to n - 1
      x = (3 * col + 2) * r
      y = (3 * row + 2) * r
      #
      h = col * step + row * step
      gcolor 999
      gcircle (x + offs * cos h) (y + offs * sin h) r
      #
      h += 180
      gcolor 000
      gcircle (x + offs * cos h) (y + offs * sin h) r
      #
      gcolor 128
      gcircle x y r
   .
.
