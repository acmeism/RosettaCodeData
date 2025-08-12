len f[] 200 * 200
func get x y .
   return f[y * 200 + x + 1]
.
proc set x y .
   grect x / 2 y / 2 0.5 0.5
   f[y * 200 + x + 1] = 1
.
gcolor 599
set 100 100
n = 6000
while i < n
   repeat
      x = random 200 - 1
      y = random 200 - 1
      until get x y <> 1
   .
   while 1 = 1
      xo = x
      yo = y
      x += random 3 - 2
      y += random 3 - 2
      if x < 0 or y < 0 or x >= 200 or y >= 200 : break 1
      if get x y = 1
         set xo yo
         i += 1
         if i mod 100 = 0 : sleep 0
         break 1
      .
   .
.
