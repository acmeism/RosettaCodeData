proc shuffle . a[] .
   for i = len a[] downto 2
      r = random i
      swap a[r] a[i]
   .
.
proc prsquare . lat[][] .
   n = len lat[][]
   for i to n
      for j to n
         write lat[i][j] & " "
      .
      print ""
   .
   print ""
.
proc square n . .
   for i to n
      lat[][] &= [ ]
      for j to n
         lat[i][] &= j
      .
   .
   shuffle lat[1][]
   for i = 2 to n - 1
      repeat
         shuffle lat[i][]
         for k to i - 1
            for j to n
               if lat[k][j] = lat[i][j]
                  break 2
               .
            .
         .
         until k = i
      .
   .
   len used0[] n
   for j to n
      used[] = used0[]
      for i to n - 1
         used[lat[i][j]] = 1
      .
      for k to n
         if used[k] = 0
            lat[n][j] = k
            break 1
         .
      .
   .
   prsquare lat[][]
.
square 5
square 5
