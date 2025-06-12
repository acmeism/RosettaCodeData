global total prim maxperi .
proc newtri s0 s1 s2 .
   p = s0 + s1 + s2
   if p <= maxperi
      prim += 1
      total += maxperi div p
      newtri s0 - 2 * s1 + 2 * s2 2 * s0 - s1 + 2 * s2 2 * s0 - 2 * s1 + 3 * s2
      newtri s0 + 2 * s1 + 2 * s2 2 * s0 + s1 + 2 * s2 2 * s0 + 2 * s1 + 3 * s2
      newtri -s0 + 2 * s1 + 2 * s2 -2 * s0 + s1 + 2 * s2 -2 * s0 + 2 * s1 + 3 * s2
   .
.
for maxperi in [ 100 10000000 ]
   prim = 0
   total = 0
   newtri 3 4 5
   print "Up to " & maxperi & ": " & total & " triples, " & prim & " primitives"
.
