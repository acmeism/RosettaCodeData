sysconf topleft
global m[] .
n = 15
nn = n * n
proc mkgrid p .
   m[] = [ ]
   for i to nn : if randomf < p
      m[] &= 0
   else
      m[] &= 1
   .
.
proc show .
   gbackground 000
   gclear
   sc = 100 / n
   for i to nn
      x = (i - 1) mod n
      y = (i - 1) div n
      if m[i] >= 1
         gcolor 999
         if m[i] = 2 : gcolor 225
         grect x * sc, y * sc, sc * 0.97, sc * 0.97
      .
   .
.
proc flood i .
   m[i] = 2
   if i > n and m[i - n] = 0 : flood (i - n)
   if i mod n <> 0 and m[i + 1] = 0 : flood (i + 1)
   if i <= nn - n and m[i + n] = 0 : flood (i + n)
   if i mod n <> 1 and m[i - 1] = 0 : flood (i - 1)
.
func test .
   for i to n : if m[i] = 0
      flood i
   .
   for i = nn - n + 1 to nn
      if m[i] = 2 : return 1
   .
   return 0
.
mkgrid 0.6
sum = test
show
ntests = 100
for p = 0.0 step 0.1 to 1.0
   sum = 0
   for i to ntests
      mkgrid p
      sum += test
   .
   print p & ": " & sum / ntests
.
