proc test d[] .
   cnt[] = [ 0 0 0 0 0 0 0 0 0 0 ]
   for d in d[] : cnt[d + 1] += 1
   for i to len d[]
      if cnt[i] <> d[i] : return
   .
   # found
   for d in d[] : write d
   print ""
.
proc backtr ind max &d[] .
   if ind > len d[]
      test d[]
      return
   .
   for d = 0 to max
      if d < 10
         d[ind] = d
         backtr ind + 1 max - d d[]
      .
   .
.
for i = 1 to 10
   len d[] i
   backtr 1 len d[] d[]
.
