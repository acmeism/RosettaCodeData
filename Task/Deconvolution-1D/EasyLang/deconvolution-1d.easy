func[] deconv g[] f[] .
   len h[] len g[] - len f[] + 1
   for n = 1 to len h[]
      h[n] = g[n]
      low = higher 1 (n - len f[] + 1)
      for i = low to n - 1
         h[n] -= h[i] * f[n - i + 1]
      .
      h[n] /= f[1]
   .
   return h[]
.
h[] = [ -8 -9 -3 -1 -6 7 ]
f[] = [ -3 -6 -1 8 -6 3 -1 -9 -9 3 -2 5 2 -2 -7 -1 ]
g[] = [ 24 75 71 -34 3 22 -45 23 245 25 52 25 -67 -96 96 31 55 36 29 -43 -7 ]
print h[]
print deconv g[] f[]
print f[]
print deconv g[] h[]
