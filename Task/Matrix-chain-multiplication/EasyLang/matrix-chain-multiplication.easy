global m[][] s[][] dims[] .
proc mat_chain_order . .
   n = len dims[] - 1
   m[][] = [ ] ; len m[][] n
   s[][] = [ ] ; len s[][] n
   for i = 1 to n
      len m[i][] n
      len s[i][] n
   .
   for lng = 2 to n
      for i = 1 to n - lng + 1
         j = i + lng - 1
         m[i][j] = 1 / 0
         for k = i to j - 1
            cost = m[i][k] + m[k + 1][j] + dims[i] * dims[k + 1] * dims[j + 1]
            if cost < m[i][j]
               m[i][j] = cost
               s[i][j] = k
            .
         .
      .
   .
.
func$ path a b .
   if a = b
      return strchar (64 + a)
   .
   return "(" & path a s[a][b] & path (s[a][b] + 1) b & ")"
.
proc pr_chain_order . .
   print "Order : " & path 1 len s[][]
.
dims[][] = [ [ 5 6 3 1 ] [ 1 5 25 30 100 70 2 1 100 250 1 1000 2 ] [ 1000 1 500 12 1 700 2500 3 2 5 14 10 ] ]
for i to len dims[][]
   dims[] = dims[i][]
   print "Dims  : " & dims[]
   mat_chain_order
   pr_chain_order
   print "Cost  : " & m[1][len s[][]]
   print ""
.
