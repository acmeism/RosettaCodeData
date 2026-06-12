global n bestlen cnt chain[] inchain[] best[] .
fastproc extendchain x pos .
   rem = bestlen - pos
   p = 1
   for i = 1 to rem : p *= 2
   if x * p < n : return
   pos += 1
   chain[pos] = x
   inchain[x + 1] = 1
   if inchain[n - x + 1] = 1
      if pos = bestlen
         cnt += 1
      else
         bestlen = pos
         cnt = 1
         len best[] pos
         for j = 1 to pos : best[j] = chain[j]
      .
   elif pos < bestlen
      for i = pos downto 1
         c = x + chain[i]
         if c < n : extendchain c pos
      .
   .
   inchain[x + 1] = 0
.
global bestres[] cntres .
proc brauer n0 .
   n = n0
   len chain[] n
   len inchain[] n + 1
   len best[] 0
   bestlen = n
   cnt = 0
   extendchain 1 0
   len bestres[] bestlen + 1
   for i = 1 to bestlen : bestres[i] = best[i]
   bestres[bestlen + 1] = n
   cntres = cnt
.
for t in [ 7 14 21 29 32 42 64 47 79 191 382 379 ]
   brauer t
   l = len bestres[] - 1
   print "L(" & t & ") = " & l & ", count of minimum chain: " & cntres
.
