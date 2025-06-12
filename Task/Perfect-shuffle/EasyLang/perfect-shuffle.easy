proc pshuffle &deck[] .
   mp = len deck[] / 2
   in[] = deck[]
   for i = 1 to mp
      deck[2 * i - 1] = in[i]
      deck[2 * i] = in[i + mp]
   .
.
proc test size .
   for i to size : deck0[] &= i
   deck[] = deck0[]
   repeat
      pshuffle deck[]
      cnt += 1
      until deck[] = deck0[]
   .
   print cnt
.
for size in [ 8 24 52 100 1020 1024 10000 ]
   test size
.
