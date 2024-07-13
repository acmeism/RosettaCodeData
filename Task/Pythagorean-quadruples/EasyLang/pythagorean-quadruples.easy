n = 2200
n2 = n * n * 2
len r[] n
len ab[] n2
for a = 1 to n
   a2 = a * a
   for b = a to n
      ab[a2 + b * b] = 1
   .
.
s = 3
for c = 1 to n
   s1 = s
   s += 2
   s2 = s
   for d = c + 1 to n
      if ab[s1] = 1
         r[d] = 1
      .
      s1 += s2
      s2 += 2
   .
.
for i to n
   if r[i] = 0
      write i & " "
   .
.
