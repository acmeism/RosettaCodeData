proc sort &d[] .
   i = 2
   j = 3
   while i <= len d[]
      if d[i - 1] <= d[i]
         i = j
         j += 1
      else
         swap d[i - 1] d[i]
         i -= 1
         if i = 1
            i = j
            j += 1
         .
      .
   .
.
data[] = [ 29 4 72 44 55 26 27 77 92 5 ]
sort data[]
print data[]
