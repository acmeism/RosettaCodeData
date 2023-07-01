BEGIN {
   # Do not put quotes round the numeric values, or the tests will fail
   a = 1    # True
   b = 0    # False

   # Boolean evaluations
   if (a) { print "first test a is true" }        # This should print
   if (b) { print "second test b is true" }       # This should not print
   if (!a) { print "third test a is false" }      # This should not print
   if (!b) { print "forth test b is false" }      # This should print

   # Boolean evaluation using comparison against zero
   if (a == 0) { print "fifth test a is false" }  # This should not print
   if (b == 0) { print "sixth test b is false" }  # This should print
   if (a != 0) { print "seventh test a is true" } # This should print
   if (b != 0) { print "eighth test b is true" }  # This should not print

 }
