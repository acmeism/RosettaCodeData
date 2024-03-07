proc rref . m[][] .
   nrow = len m[][]
   ncol = len m[1][]
   lead = 1
   for r to nrow
      if lead > ncol
         return
      .
      i = r
      while m[i][lead] = 0
         i += 1
         if i > nrow
            i = r
            lead += 1
            if lead > ncol
               return
            .
         .
      .
      swap m[i][] m[r][]
      m = m[r][lead]
      for k to ncol
         m[r][k] /= m
      .
      for i to nrow
         if i <> r
            m = m[i][lead]
            for k to ncol
               m[i][k] -= m * m[r][k]
            .
         .
      .
      lead += 1
   .
.
test[][] = [ [ 1 2 -1 -4 ] [ 2 3 -1 -11 ] [ -2 0 -3 22 ] ]
rref test[][]
print test[][]
