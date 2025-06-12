func dice5 .
   return random 5
.
func dice25 .
   return (dice5 - 1) * 5 + dice5
.
func dice7a .
   return dice25 mod1 7
.
func dice7b .
   repeat
      h = dice25
      until h <= 21
   .
   return h mod1 7
.
numfmt 0 3
#
proc checkdist dicefunc n delta .
   len dist[] 7
   for i to n
      # no function pointers
      if dicefunc = 1
         h = dice7a
      else
         h = dice7b
      .
      dist[h] += 1
   .
   for i to len dist[]
      h = dist[i] / n * 7
      if abs (h - 1) > delta : bad = 1
      dist[i] = 0
      print h
   .
   if bad = 1
      print "-> not uniform"
   else
      print "-> uniform"
   .
   print ""
.
#
checkdist 1 1000000 0.01
checkdist 2 1000000 0.01
