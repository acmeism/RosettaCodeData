func logn n .
   return log n 0
.
func randnorm .
   return cos (360 * randomf) * sqrt (-2 * logn randomf)
.
global smpl[] .
func mean .
   for v in smpl[] : sum += v
   return sum / len smpl[]
.
func stddev .
   avg = mean
   for v in smpl[] : squares += (avg - v) * (avg - v)
   return sqrt (squares / len smpl[])
.
proc mksmpl n .
   smpl[] = [ ]
   for i to n
      v = 100 + randnorm * 15
      smpl[] &= v
   .
.
proc histo .
   len count[] 199
   for v in smpl[]
      ind = floor (v + 0.5)
      ind = higher 1 ind
      ind = lower 199 ind
      count[ind] += 1
   .
   n = len smpl[]
   for i = 40 to 160
      v = count[i]
      h = floor (v * 1500 / n)
      s$ = ""
      for j to h : s$ &= "*"
      print i & " " & v & " " & s$
   .
.
numfmt 5 4
proc stats size .
   mksmpl size
   print "Size:   " & size
   print "Mean:   " & mean
   print "Stddev: " & stddev
   print ""
   histo
   print ""
.
stats 1000000
