fastfunc ends89 n .
   repeat
      s = 0
      while n > 0
         d = n mod 10
         s += d * d
         n = n div 10
      .
      n = s
      if n = 89
         return 1
      .
      until n = 1
   .
   return 0
.
k = 8
arrbase sums[] 0
len sums[] k * 81 + 1
sums[0] = 1
for n = 1 to k
   for i = n * 81 downto 1
      for j = 1 to 9
         s = j * j
         if s > i
            break 1
         .
         sums[i] += sums[i - s]
      .
   .
.
cnt = 0
for i = 1 to k * 81
   if ends89 i = 1
      cnt += sums[i]
   .
.
print cnt
