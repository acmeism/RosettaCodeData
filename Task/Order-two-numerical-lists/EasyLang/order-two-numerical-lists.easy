func listcmp a[] b[] .
   for i to lower len a[] len b[]
      if a[i] < b[i]
         return -1
      elif a[i] > b[i]
         return 1
      .
   .
   if len a[] < len b[]
      return -1
   elif len a[] > len b[]
      return 1
   .
   return 0
.
print listcmp [ 2 4 5 ] [ 2 3 1 ]
print listcmp [ 2 3 1 ] [ 2 3 1 ]
print listcmp [ 2 3 1 ] [ 2 3 1 3 ]
