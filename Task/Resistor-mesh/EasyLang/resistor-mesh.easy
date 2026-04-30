n = 10
nn = n * n
len g[][] nn
for i to nn : len g[i][] nn + 1
#
for row = 1 to n
   for col = 1 to n
      node += 1
      if row > 1
         g[node][node] += 1
         g[node][node - n] = -1
      .
      if row < n
         g[node][node] += 1
         g[node][node + n] = -1
      .
      if col > 1
         g[node][node] += 1
         g[node][node - 1] = -1
      .
      if col < n
         g[node][node] += 1
         g[node][node + 1] = -1
      .
   .
.
ar = 2
ac = 2
br = 7
bc = 8
a = ac + n * (ar - 1)
b = bc + n * (br - 1)
g[a][nn + 1] = -1
g[b][nn + 1] = 1
print "Nodes a: " & a & " b: " & b
for j = 1 to nn
   for i = j to nn
      if g[i][j] <> 0 : break 1
   .
   if i = nn + 1
      print "No solution"
      return
   .
   for k = 1 to nn + 1
      swap g[j][k] g[i][k]
   .
   y = g[j][j]
   for k = 1 to nn + 1
      g[j][k] = g[j][k] / y
   .
   for i = 1 to nn : if i <> j
      y = -g[i][j]
      for k = 1 to nn + 1
         g[i][k] = g[i][k] + y * g[j][k]
      .
   .
.
print ""
numfmt 0 14
print "Resistance = " & abs (g[a][nn + 1] - g[b][nn + 1]) & " Ohm"
