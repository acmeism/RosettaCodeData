min = 1
max = 100
print "Think of a number between " & min & " and " & max
print "I will try to guess your number."
repeat
   guess = (min + max) div 2
   print "My guess is " & guess
   write "Is it higher than, lower than or equal to your number? "
   answer$ = input
   print answer$
   ans$ = substr answer$ 1 1
   until ans$ = "e"
   if ans$ = "l"
      min = guess + 1
   elif ans$ = "h"
      max = guess - 1
   else
      print "Sorry, i didn't understand your answer."
   .
.
print "Goodbye."
