func aeq a b .
   return if abs (a - b) <= abs a * 1e-14
.
proc test a b . .
   write a & " " & b & " -> "
   if aeq a b = 1
      print "true"
   else
      print "false"
   .
.
numfmt 10 0
test 100000000000000.01 100000000000000.011
test 100.01 100.011
test 10000000000000.001 / 10000 1000000000.0000001
test 0.001 0.0010000001
test 1.01e-22 0
test sqrt 2 * sqrt 2 2
test -sqrt 2 * sqrt 2 -2
test 3.14159265358979323846 3.14159265358979324
