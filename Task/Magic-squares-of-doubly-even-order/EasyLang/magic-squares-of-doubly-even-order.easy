func[][] mkarr s .
   len q[][] s
   for i = 1 to s
      len q[i][] s
   .
   return q[][]
.
func[][] mk_oms s .
   q[][] = mkarr s
   r = 1
   c = 1 + s div 2
   for p = 1 to s * s
      q[r][c] = p
      tc = c + 1
      if tc > s
         tc = 1
      .
      tr = r - 1
      if tr < 1
         tr = s
      .
      if q[tr][tc] <> 0
         tc = c
         tr = r + 1
      .
      c = tc
      r = tr
   .
   return q[][]
.
func[][] mk_dems s .
   q[][] = mkarr s
   tmp[][] = [ [ 1 0 0 1 ] [ 0 1 1 0 ] [ 0 1 1 0 ] [ 1 0 0 1 ] ]
   tot = s * s
   for r = 1 to s
      for c = 1 to s
         sx = c mod 4
         if sx < 1
            sx = 4
         .
         sy = r mod 4
         if sy < 1
            sy = 4
         .
         if tmp[sy][sx] = 1
            q[r][c] = n + 1
         else
            q[r][c] = tot - n
         .
         n += 1
      .
   .
   return q[][]
.
numfmt 0 2
print mk_dems 8
