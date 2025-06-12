proc shellsort &a[] .
   inc = len a[] div 2
   while inc > 0
      for i = inc to len a[]
         tmp = a[i]
         j = i
         while j > inc and a[j - inc] > tmp
            a[j] = a[j - inc]
            j = j - inc
         .
         a[j] = tmp
      .
      inc = floor (0.5 + inc / 2.2)
   .
.
a[] = [ -12 3 0 4 7 4 8 -5 9 ]
shellsort a[]
print a[]
