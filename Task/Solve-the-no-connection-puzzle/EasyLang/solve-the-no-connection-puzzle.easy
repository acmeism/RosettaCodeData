cons[][] = [ [ 3 4 5 ] [ 4 5 6 ] [ 4 7 ] [ 5 7 8 ] [ 6 7 8 ] [ 8 ] [ ] [ ] ]
n = len cons[][]
len peg[] n
#
proc init .
   for i to n : peg[i] = i
.
init
#
proc permute k .
   for i = k to n
      swap peg[i] peg[k]
      permute k + 1
      swap peg[k] peg[i]
   .
   if k = n
      for i to n : for j in cons[i][]
         if abs (peg[i] - peg[j]) = 1 : break 2
      .
      if i > n : print peg[]
   .
.
permute 1
