func[][] ncsub seq[] s .
   if len seq[] = 0
      if s >= 3
         return [ [ ] ]
      .
      return [ ]
   .
   last = seq[$]
   len seq[] -1
   res[][] = ncsub seq[] (s + s mod 2)
   r[][] = ncsub seq[] (s + 1 - s mod 2)
   for i to len r[][]
      r[i][] &= last
      res[][] &= r[i][]
   .
   return res[][]
.
print ncsub [ 1 2 3 4 ] 0
