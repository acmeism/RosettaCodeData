# Heap's Algorithm
sig = 1
proc generate k &ar[] .
   if k = 1
      print ar[] & "  " & sig
      sig = -sig
      return
   .
   generate k - 1 ar[]
   for i to k - 1
      if k mod 2 = 0
         swap ar[i] ar[k]
      else
         swap ar[1] ar[k]
      .
      generate k - 1 ar[]
   .
.
ar[] = [ 1 2 3 ]
generate len ar[] ar[]
