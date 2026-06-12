numfmt 15 12
a = 0
b = 1
n = 10
len coef[] n
len cheby[] n
for i = 0 to n - 1
   coef[i + 1] = cos (180 / pi * (cos (180 / n * (i + 1 / 2)) * (b - a) / 2 + (b + a) / 2))
.
for i = 0 to n - 1
   w = 0
   for j = 0 to n - 1
      w += coef[j + 1] * cos (180 / n * i * (j + 1 / 2))
   .
   cheby[i + 1] = w * 2 / n
   print cheby[i + 1]
.
