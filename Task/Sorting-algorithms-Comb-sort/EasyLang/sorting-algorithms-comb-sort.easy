proc combsort &d[] .
   gap = len d[]
   while gap > 1 or swaps = 1
      gap = higher 1 (gap div 1.25)
      swaps = 0
      for i = 1 to len d[] - gap
         j = i + gap
         if d[i] > d[j]
            swap d[i] d[j]
            swaps = 1
         .
      .
   .
.
d[] = [ 88 18 31 44 4 0 8 81 14 78 20 76 84 33 73 75 82 5 62 70 ]
combsort d[]
print d[]
