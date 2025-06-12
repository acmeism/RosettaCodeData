proc hanoi n src dst aux .
   if n >= 1
      hanoi n - 1 src aux dst
      print "Move " & src & " to " & dst
      hanoi n - 1 aux dst src
   .
.
hanoi 4 1 2 3
