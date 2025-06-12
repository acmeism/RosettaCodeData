numfmt 0 6
y = 1
for i = 0 to 100
   t = i / 10
   if t = floor t
      h = t * t + 4
      actual = h * h / 16
      print "y(" & t & ") = " & y & " Error = " & actual - y
   .
   k1 = t * sqrt y
   k2 = (t + 0.05) * sqrt (y + 0.05 * k1)
   k3 = (t + 0.05) * sqrt (y + 0.05 * k2)
   k4 = (t + 0.10) * sqrt (y + 0.10 * k3)
   y += 0.1 * (k1 + 2 * (k2 + k3) + k4) / 6
.
