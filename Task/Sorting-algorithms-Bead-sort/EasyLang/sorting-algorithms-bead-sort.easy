proc beadSort &a[] .
   for i to len a[] : max = higher max a[i]
   len beads[][] len a[]
   for i to len a[]
      len beads[i][] max
      for j to a[i] : beads[i][j] = 1
   .
   for j to max
      sum = 0
      for i = 1 to len a[]
         sum += beads[i][j]
         beads[i][j] = 0
      .
      for i = len a[] downto len a[] - sum + 1
         a[i] = j
      .
   .
.
a[] = [ 4 38 100 1 25 69 69 16 8 59 71 53 33 ]
beadSort a[]
print a[]
