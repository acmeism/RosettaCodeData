func p l n .
   log = log10 2
   factor = 1
   loop = l
   while loop > 10
      factor *= 10
      loop = loop div 10
   .
   while n > 0
      test += 1
      val = floor (factor * pow 10 (test * log mod 1))
      if val = l
         n -= 1
      .
   .
   return test
.
proc test l n . .
   print "p(" & l & ", " & n & ") = " & p l n
.
test 12 1
test 12 2
test 123 45
test 123 12345
test 123 678910
