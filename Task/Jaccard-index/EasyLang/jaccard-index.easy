func jaccard a[] b[] .
   union = len b[] + len a[]
   for a in a[] : for b in b[]
      if a = b
         intersect += 1
         union -= 1
      .
   .
   if union = 0 : return 1
   return intersect / union
.
tests[][] = [ [ ] [ 1 2 3 4 5 ] [ 1 3 5 7 9 ] [ 2 4 6 8 10 ] [ 2 3 5 7 ] [ 8 ] ]
for i to len tests[][]
   for j = i to len tests[][]
      if i <> j
         write "J(" & strchar (64 + i) & ", " & strchar (64 + j) & ") ➜ " & jaccard tests[i][] tests[j][] & "\t"
      .
      print "J(" & strchar (64 + j) & ", " & strchar (64 + i) & ") ➜ " & jaccard tests[j][] tests[i][]
   .
.
