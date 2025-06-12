proc floydwarshall w[][] n .
   for i to n
      con[][] &= [ ]
      for j to n : con[i][] &= 1 / 0
   .
   for i to len w[][]
      con[w[i][1]][w[i][2]] = w[i][3]
   .
   for k to n
      for i to n
         for j to n
            con[i][j] = lower con[i][j] (con[i][k] + con[k][j])
         .
      .
   .
   for i to n
      for j to n
         if i <> j
            print i & " -> " & j & " : " & con[i][j]
         .
      .
   .
.
floydwarshall [ [ 1 3 -2 ] [ 2 1 4 ] [ 2 3 3 ] [ 3 4 2 ] [ 4 2 -1 ] ] 4
