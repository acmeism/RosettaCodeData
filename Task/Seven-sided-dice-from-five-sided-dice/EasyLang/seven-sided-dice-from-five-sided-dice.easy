func dice5 .
   return randint 5
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
numfmt 3 0
n = 1000000
len dist[] 7
#
proc checkdist . .
   for i to len dist[]
      h = dist[i] / n * 7
      if abs (h - 1) > 0.01
         bad = 1
      .
      dist[i] = 0
      print h
   .
   if bad = 1
      print "-> not uniform"
   else
      print "-> uniform"
   .
.
#
for i to n
   dist[dice7a] += 1
.
checkdist
#
print ""
for i to n
   dist[dice7b] += 1
.
checkdist
