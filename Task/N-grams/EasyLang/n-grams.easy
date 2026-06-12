global gram$[] cnt[] .
proc add g$ .
   for i to len gram$[]
      if gram$[i] = g$
         cnt[i] += 1
         return
      .
   .
   gram$[] &= g$
   cnt[] &= 1
.
proc ngram s$ n .
   gram$[] = [ ]
   cnt[] = [ ]
   for i = 1 to len s$ - n + 1
      add substr s$ i n
   .
   for i to len gram$[]
      write "('" & gram$[i] & "':" & cnt[i] & ") "
   .
   print ""
.
for k = 2 to 4
   ngram "LIVE AND LET LIVE" k
   print ""
.
