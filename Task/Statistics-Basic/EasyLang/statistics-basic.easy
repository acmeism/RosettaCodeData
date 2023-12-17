global list[] .
proc mklist n . .
   list[] = [ ]
   for i = 1 to n
      list[] &= randomf
   .
.
func mean .
   for v in list[]
      sum += v
   .
   return sum / len list[]
.
func stddev .
   avg = mean
   for v in list[]
      squares += (avg - v) * (avg - v)
   .
   return sqrt (squares / len list[])
.
proc histo . .
   len hist[] 10
   for v in list[]
      ind = floor (v * 10) + 1
      hist[ind] += 1
   .
   for v in hist[]
      h = floor (v / len list[] * 200 + 0.5)
      s$ = substr "========================================" 1 h
      print v & " " & s$
   .
.
numfmt 4 5
proc stats size . .
   mklist size
   print "Size:   " & size
   print "Mean:   " & mean
   print "Stddev: " & stddev
   histo
   print ""
.
stats 100
stats 1000
stats 10000
stats 100000
