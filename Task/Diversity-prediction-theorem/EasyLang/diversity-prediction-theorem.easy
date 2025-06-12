proc calc TrueVal test[] .
   for test in test[]
      h = (test - TrueVal)
      Vari += h * h
      Sum += test
      c += 1
   .
   AvgErr = Vari / c
   RefAvg = Sum / c
   h = (TrueVal - RefAvg)
   CrowdErr = h * h
   print "Average error : " & AvgErr
   print "Crowd error   : " & CrowdErr
   print "Diversity     : " & AvgErr - CrowdErr
   print ""
.
calc 49 [ 48 47 51 ]
calc 49 [ 48 47 51 42 ]
