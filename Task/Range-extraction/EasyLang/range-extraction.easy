func$ extract l[] .
   for i to len l[]
      low = l[i]
      while i < len l[] and l[i] + 1 = l[i + 1]
         i += 1
      .
      hi = l[i]
      if hi - low >= 2
         r$ &= low & "-" & hi & ","
      elif hi - low = 1
         r$ &= low & ","
         r$ &= hi & ","
      else
         r$ &= low & ","
      .
   .
   return substr r$ 1 (len r$ - 1)
.
print extract [ 0 1 2 4 6 7 8 11 12 14 15 16 17 18 19 20 21 22 23 24 25 27 28 29 30 31 32 33 35 36 37 38 39 ]
