g[][] = [ [ 1 ] [ 2 ] [ 0 ] [ 1 2 4 ] [ 3 5 ] [ 2 6 ] [ 5 ] [ 4 6 7 ] ]
gc = len g[][]
len vis[] gc
len l[] gc
x = gc
len t[][] gc
proc visit u .
   if vis[u] = 0
      vis[u] = 1
      for v in g[u][]
         v += 1
         visit v
         t[v][] &= u
      .
      l[x] = u
      x -= 1
   .
.
for i to gc
   visit i
.
len c[] gc
proc assign u root .
   if vis[u] = 1
      vis[u] = 0
      c[u] = root
      for v in t[u][]
         assign v root
      .
   .
.
for u in l[]
   assign u u
.
for v in c[] : write v - 1 & " "
print ""

µ
