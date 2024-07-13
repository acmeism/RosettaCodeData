func[][] init n .
   for m = 1 to n
      res[][] &= [ ]
      for p = 1 to n
         res[m][] &= 0
      .
   .
   return res[][]
.
func[][] pasupper n .
   res[][] = init 5
   for p = 1 to n
      res[1][p] = 1
   .
   for i = 2 to n
      for j = 2 to i
         res[j][i] = res[j][i - 1] + res[j - 1][i - 1]
      .
   .
   return res[][]
.
func[][] paslower n .
   res[][] = init 5
   for p = 1 to n
      res[p][1] = 1
   .
   for i = 2 to n
      for j = 2 to i
         res[i][j] = res[i - 1][j] + res[i - 1][j - 1]
      .
   .
   return res[][]
.
func[][] passym n .
   res[][] = init 5
   for p = 1 to n
      res[1][p] = 1
      res[p][1] = 1
   .
   for i = 2 to n
      for j = 2 to n
         res[i][j] = res[i - 1][j] + res[i][j - 1]
      .
   .
   return res[][]
.
print pasupper 5
print paslower 5
print passym 5
