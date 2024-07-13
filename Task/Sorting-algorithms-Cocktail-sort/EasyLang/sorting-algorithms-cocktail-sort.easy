proc sort . d[] .
   a = 1
   b = len d[] - 1
   while a <= b
      h = a
      for i = a to b
         if d[i] > d[i + 1]
            swap d[i] d[i + 1]
            h = i
         .
      .
      b = h - 1
      h = b
      for i = b downto a
         if d[i] > d[i + 1]
            swap d[i] d[i + 1]
            h = i
         .
      .
      a = h + 1
   .
.
l[] = [ 5 6 1 2 9 14 2 15 6 7 8 97 ]
sort l[]
print l[]
