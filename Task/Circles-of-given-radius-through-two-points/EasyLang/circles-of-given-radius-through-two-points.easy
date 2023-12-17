func$ fmt a b .
   return "(" & a & " " & b & ")"
.
proc test m1x m1y m2x m2y r . .
   print "Points: " & fmt m1x m1y & " " & fmt m2x m2y & " Radius: " & r
   if r = 0
      print "Radius of zero gives no circles"
      print ""
      return
   .
   x = (m2x - m1x) / 2
   y = (m2y - m1y) / 2
   bx = m1x + x
   by = m1y + y
   pb = sqrt (x * x + y * y)
   if pb = 0
      print "Coincident points give infinite circles"
      print ""
      return
   .
   if pb > r
      print "Points are too far apart for the given radius"
      print ""
      return
   .
   cb = sqrt (r * r - pb * pb)
   x1 = y * cb / pb
   y1 = x * cb / pb
   print "Circles: " & fmt (bx - x1) (by + y1) & " " & fmt (bx + x1) (by - y1)
   print ""
.
test 0.1234 0.9876 0.8765 0.2345 2.0
test 0.0000 2.0000 0.0000 0.0000 1.0
test 0.1234 0.9876 0.1234 0.9876 2.0
test 0.1234 0.9876 0.8765 0.2345 0.5
test 0.1234 0.9876 0.1234 0.9876 0.0
