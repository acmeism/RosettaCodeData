n = 6000
len p[] n + 4
for i = 2 to sqrt len p[]
   if p[i] = 0
      for j = i * 2 step i to len p[]
         p[j] = 1
      .
   .
.
for i = 3 to n - 1
   if p[i - 1] = 0 and p[i + 3] = 0 and p[i + 5] = 0
      print i & ": " & i - 1 & " " & i + 3 & " " & i + 5
   .
.
