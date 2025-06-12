proc rref &m[][] .
   nrow = len m[][]
   ncol = len m[1][]
   lead = 1
   for r to nrow
      if lead > ncol : return
      i = r
      while m[i][lead] = 0
         i += 1
         if i > nrow
            i = r
            lead += 1
            if lead > ncol : return
         .
      .
      swap m[i][] m[r][]
      m = m[r][lead]
      for k to ncol : m[r][k] /= m
      for i to nrow
         if i <> r
            m = m[i][lead]
            for k to ncol : m[i][k] -= m * m[r][k]
         .
      .
      lead += 1
   .
.
proc inverse &mat[][] &inv[][] .
   inv[][] = [ ]
   ln = len mat[][]
   for i to ln
      if len mat[i][] <> ln
         # not a square matrix
         return
      .
      aug[][] &= [ ]
      len aug[i][] 2 * ln
      for j to ln : aug[i][j] = mat[i][j]
      aug[i][ln + i] = 1
   .
   rref aug[][]
   for i to ln
      inv[][] &= [ ]
      for j = ln + 1 to 2 * ln
         inv[i][] &= aug[i][j]
      .
   .
.
test[][] = [ [ 1 2 3 ] [ 4 1 6 ] [ 7 8 9 ] ]
inverse test[][] inv[][]
print inv[][]
