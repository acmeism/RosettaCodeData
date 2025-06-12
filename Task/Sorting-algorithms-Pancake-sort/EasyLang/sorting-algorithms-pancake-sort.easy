global a[] .
proc flip n .
   for i = 1 to n div 2
      swap a[i] a[n - i + 1]
   .
   # print "flip (1 .. " & n & ") : " & a[]
.
func[] minmax n .
   pmin = 1
   pmax = 1
   for i = 2 to n
      if a[i] > a[pmax]
         pmax = i
      elif a[i] < a[pmin]
         pmin = i
      .
   .
   return [ pmin pmax ]
.
proc pcsort n dir .
   if n = 1
      return
   .
   r[] = minmax n
   bestx = r[dir]
   altx = r[3 - dir]
   flipped = 0
   if bestx = n
      n -= 1
   elif bestx = 1
      flip n
      n -= 1
   elif altx = n
      dir = 3 - dir
      n -= 1
      flipped = 1
   else
      flip bestx
   .
   pcsort n dir
   if flipped = 1
      flip n + 1
   .
.
a[] = [ 6 7 2 1 8 9 5 3 4 ]
print a[]
pcsort len a[] 2
print a[]
