fastfunc isprim num .
   # test only odd numbers
   i = 3
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 2
   .
   return 1
.
func nextprim num .
   repeat
      num += 2
      until isprim num = 1
   .
   return num
.
len d[][] 9
for i to 9
   len d[i][] 9
.
d[2][3] = 1
p = 3
for i to 1000000
   pp = p
   p = nextprim p
   d[pp mod 10][p mod 10] += 1
.
for i to 9
   for j to 9
      if d[i][j] > 0
         print i & " -> " & j & ": " & d[i][j] & " = " & d[i][j] / 10000 & "%"
      .
   .
.
