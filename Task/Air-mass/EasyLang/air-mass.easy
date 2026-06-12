func rho a .
   return pow 2.718281828459 (-a / 8500)
.
func height a z d .
   AA = 6371000 + a
   HH = sqrt (AA * AA + d * d - 2 * d * AA * cos (180 - z))
   return HH - 6371000
.
func density a z .
   while d < 10000000
      delta = higher 0.001 (0.001 * d)
      sum += rho height a z (d + 0.5 * delta) * delta
      d += delta
   .
   return sum
.
func airmass a z .
   return density a z / density a 0
.
numfmt 2 8
print "Angle   0 m      13700 m"
print "------------------------"
for z = 0 step 5 to 90
   print z & "   " & airmass 0 z & " " & airmass 13700 z
.
