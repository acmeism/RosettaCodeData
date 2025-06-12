func[][] mkarr s .
   len q[][] s
   for i = 1 to s : len q[i][] s
   return q[][]
.
func[][] mk_oms s .
   q[][] = mkarr s
   r = 1
   c = 1 + s div 2
   for p = 1 to s * s
      q[r][c] = p
      tc = c + 1
      if tc > s : tc = 1
      tr = r - 1
      if tr < 1 : tr = s
      if q[tr][tc] <> 0
         tc = c
         tr = r + 1
      .
      c = tc
      r = tr
   .
   return q[][]
.
func[][] mk_sems s .
   q[][] = mkarr s
   sh = s div 2
   q4 = sh * sh
   q2 = 2 * q4
   q3 = 3 * q4
   o[][] = mk_oms sh
   for r = 1 to sh
      for c = 1 to sh
         q1 = o[r][c]
         q[r][c] = q1
         q[r + sh][c + sh] = q1 + q4
         q[r][c + sh] = q1 + q2
         q[r + sh][c] = q1 + q3
      .
   .
   lc = sh div 2
   rc = lc - 1
   for r = 1 to sh
      for c = 1 to s
         if c <= lc or c > s - rc or (c = lc + 1 and r = lc + 1)
            if c <> 1 or r <> lc + 1
               t = q[r][c]
               q[r][c] = q[r + sh][c]
               q[r + sh][c] = t
            .
         .
      .
   .
   return q[][]
.
numfmt 2 0
r[][] = mk_sems 6
for i to len r[][] : print r[i][]
