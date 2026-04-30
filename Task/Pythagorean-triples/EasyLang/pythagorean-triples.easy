global total prim maxperi .
fastproc newtri s0 s1 s2 .
   while 1 = 1
      p = s0 + s1 + s2
      if p > maxperi : return
      prim += 1
      total += maxperi div p
      newtri s0 - 2 * s1 + 2 * s2, 2 * s0 - s1 + 2 * s2, 2 * s0 - 2 * s1 + 3 * s2
      newtri s0 + 2 * s1 + 2 * s2, 2 * s0 + s1 + 2 * s2, 2 * s0 + 2 * s1 + 3 * s2
      h0 = -s0 + 2 * s1 + 2 * s2
      h1 = -2 * s0 + s1 + 2 * s2
      s2 = -2 * s0 + 2 * s1 + 3 * s2
      s0 = h0
      s1 = h1
   .
.
for maxperi in [ 100 10000000 ]
   prim = 0
   total = 0
   newtri 3 4 5
   print "Up to " & maxperi & ": " & total & " triples, " & prim & " primitives"
.
