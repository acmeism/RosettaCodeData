proc out w[][] .
   numfmt 3 0
   for i to len w[][]
      for j to len w[i][]
         write w[i][j]
      .
      print ""
   .
   print ""
   numfmt 0 0
.
proc walshmatr ord .
   n = pow 2 ord
   len walsh[][] n
   for i to n : len walsh[i][] n
   walsh[1][1] = 1
   k = 1
   while k < n
      for i = 1 to k
         for j = 1 to k
            walsh[i + k][j] = walsh[i][j]
            walsh[i][j + k] = walsh[i][j]
            walsh[i + k][j + k] = -walsh[i][j]
         .
      .
      k *= 2
   .
   print "Walsh matrix of order " & ord
   out walsh[][]
.
walshmatr 2
walshmatr 4
