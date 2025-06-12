numfmt 6 3
for p in [ 0.1 0.3 0.5 0.7 0.9 ]
   theory = p * (1 - p)
   print "p:" & p & " theory:" & theory
   print "    n    sim"
   for n in [ 1e2 1e3 1e4 ]
      sum = 0
      for t to 100
         run = 0
         for j to n
            h = if randomf < p
            if h = 1 and run = 0 : sum += 1
            run = h
         .
      .
      print n & "  " & sum / n / t
   .
   print ""
.
