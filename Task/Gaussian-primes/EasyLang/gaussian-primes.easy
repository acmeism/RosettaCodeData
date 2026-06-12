func norm c[] .
   return c[1] * c[1] + c[2] * c[2]
.
fastfunc isprim n .
   if n < 2 : return 0
   i = 2
   while i <= sqrt n
      if n mod i = 0 : return 0
      i += 1
   .
   return 1
.
func isgausprim c[] .
   re = abs c[1]
   im = abs c[2]
   if re = 0 : return if bitand im 3 = 3 and isprim im = 1
   if im = 0 : return if bitand re 3 = 3 and isprim re = 1
   return isprim norm c[]
.
radius = 10
max = radius * radius
for x = -radius to radius : for y = -radius to radius
   c[] = [ x y ]
   if norm c[] < max and isgausprim c[] = 1
      write c[] & " "
   .
.
print ""
radius = 50
max = radius * radius
for x = -radius to radius : for y = -radius to radius
   c[] = [ x y ]
   if norm c[] < max and isgausprim c[] = 1
      gcircle 50 + x 50 + y 0.5
   .
.
