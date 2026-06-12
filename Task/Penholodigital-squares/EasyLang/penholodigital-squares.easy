global k digs[] .
fastproc nextperm .
   n = len digs[]
   k = n - 1
   while k >= 1 and digs[k + 1] < digs[k] : k -= 1
   if k = 0 : return
   l = n
   while digs[l] < digs[k] : l -= 1
   swap digs[l] digs[k]
   k += 1
   while k < n
      swap digs[k] digs[n]
      k += 1
      n -= 1
   .
.
global r[] .
fastproc penhold b .
   len digs[] b - 1
   for i to b - 1 : digs[i] = i
   len r[] 0
   repeat
      n = 0
      for d in digs[] : n = n * b + d
      if sqrt n mod 1 = 0 : r[] &= n
      nextperm
      until k = 0
   .
.
func$ base n b .
   if n = 0 : return ""
   d = n mod b + 48
   if d >= 58 : d += 39
   return base (n div b) b & strchar d
.
for b in [ 9 10 11 12 ]
   penhold b
   print len r[] & " Penholodigital squares in base " & b & ":"
   for i to len r[]
      write base sqrt r[i] b & "² = " & base r[i] b & "   "
      if i mod 3 = 0 : print ""
   .
   if len r[] mod 3 <> 0 : print ""
   print ""
.
