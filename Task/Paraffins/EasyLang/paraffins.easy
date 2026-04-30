func[] bn s$ .
   i = len s$ - 7 + 1
   while i >= -5
      r[] &= number substr s$ i 7
      i -= 7
   .
   return r[]
.
func$ str bn[] .
   s$ = bn[$]
   for i = len bn[] - 1 downto 1
      h$ = bn[i]
      s$ &= substr "0000000" 1 (7 - len h$) & h$
   .
   return s$
.
func[] bnmul a[] b[] .
   len r[] len a[] + len b[]
   if len a[] > len b[] : swap a[] b[]
   for ia = 1 to len a[]
      h = 0
      for ib = 1 to len b[]
         h += r[ia + ib - 1] + b[ib] * a[ia]
         r[ia + ib - 1] = h mod 10000000
         h = h div 10000000
      .
      r[ia + ib - 1] += h
   .
   while r[$] = 0 and len r[] > 1 : len r[] -1
   return r[]
.
func[] bnadd a[] b[] .
   if len b[] > len a[] : swap a[] b[]
   len r[] len a[]
   for i = 1 to len r[]
      v = 0
      if i <= len b[] : v = b[i]
      h += a[i] + v
      r[i] = h mod 10000000
      h = h div 10000000
   .
   if h > 0 : r[] &= h
   while r[$] = 0 and len r[] > 1 : len r[] -1
   return r[]
.
func bncmp a[] b[] .
   if len a[] > len b[] : return 1
   if len a[] < len b[] : return -1
   for i = len a[] downto 1
      if a[i] > b[i] : return 1
      if a[i] < b[i] : return -1
   .
   return 0
.
func[] bnsub a[] b[] .
   len r[] len a[]
   for i = 1 to len r[]
      v = 0
      if i <= len b[] : v = b[i]
      h = a[i] - v - h
      if h < 0
         r[i] = h + 10000000
         h = 1
      else
         r[i] = h
         h = 0
      .
   .
   while len r[] > 1 and r[$] = 0 : len r[] -1
   return r[]
.
func[][] bndivmod a[] b[] .
   if bncmp a[] b[] < 0 : return [ [ 0 ] a[] ]
   lb = len b[]
   d = 10000000 div (b[lb] + 1)
   if d > 1
      for i = 1 to lb
         carry += b[i] * d
         b[i] = carry mod 10000000
         carry = carry div 10000000
      .
      for i = 1 to len a[]
         carry += a[i] * d
         a[i] = carry mod 10000000
         carry = carry div 10000000
      .
   .
   a[] &= carry
   #
   len q[] len a[] - lb
   v1 = b[lb]
   if lb >= 2 : v2 = b[lb - 1]
   for j = len q[] downto 1
      u0 = a[j + lb]
      u1 = a[j + lb - 1]
      u2 = 0
      if j + lb >= 2 : u2 = a[j + lb - 2]
      if u0 = v1
         qhat = 9999999
         rhat = u1 + v1
      else
         h = u0 * 10000000 + u1
         qhat = h div v1
         rhat = h mod v1
      .
      while rhat < 10000000 and qhat * v2 > 10000000 * rhat + u2
         qhat -= 1
         rhat += v1
      .
      k = 0
      for i = 1 to lb
         p = qhat * b[i] + k
         k = p div 10000000
         t = a[j + i - 1] - (p mod 10000000)
         if t < 0
            t += 10000000
            k += 1
         .
         a[j + i - 1] = t
      .
      t = a[j + lb] - k
      if t < 0
         qhat -= 1
         k = 0
         for i = 1 to lb
            t = a[j + i - 1] + b[i] + k
            a[j + i - 1] = t mod 10000000
            k = t div 10000000
         .
         a[j + lb] = t + k
      else
         a[j + lb] = t
      .
      q[j] = qhat
   .
   if d > 1
      k = 0
      for i = lb downto 1
         t = k * 10000000 + a[i]
         a[i] = t div d
         k = t mod d
      .
   .
   len a[] lb
   while len q[] > 1 and q[len q[]] = 0 : len q[] len q[] - 1
   while len a[] > 1 and a[len a[]] = 0 : len a[] len a[] - 1
   return [ q[] a[] ]
.
func[] bnmod a[] n[] .
   result[][] = bndivmod a[] n[]
   return result[2][]
.
func[] bndiv a[] n[] .
   result[][] = bndivmod a[] n[]
   return result[1][]
.
#
nMax = 250
nBranches = 4
len rooted[][] nMax + 1
len unrooted[][] nMax + 1
# 0-based - 0 is last
for i = 0 to nMax
   rooted[i][] = [ 0 ]
   unrooted[i][] = [ 0 ]
.
rooted[0][] = [ 1 ]
rooted[1][] = [ 1 ]
unrooted[0][] = [ 1 ]
unrooted[1][] = [ 1 ]
func[] choose m[] k .
   res[] = m[]
   for i = 1 to k - 1
      res[] = bnmul res[] bnadd m[] [ i ]
      res[] = bndiv res[] [ i + 1 ]
   .
   return res[]
.
proc tree br n l sum cnt[] .
   for b = br + 1 to nBranches
      s = sum + (b - br) * n
      if s > nMax : return
      c[] = bnmul choose rooted[n][] (b - br) cnt[]
      if l * 2 < s : unrooted[s][] = bnadd unrooted[s][] c[]
      if b = nBranches : return
      rooted[s][] = bnadd rooted[s][] c[]
      for m = n - 1 downto 1
         tree b m l s c[]
      .
   .
.
proc bicenter s .
   if s mod 2 = 0
      rhalf[] = rooted[s div 2][]
      term[] = bnmul rhalf[] bnadd rhalf[] [ 1 ]
      unrooted[s][] = bnadd unrooted[s][] bndiv term[] [ 2 ]
   .
.
for n = 1 to nMax
   tree 0 n n 1 [ 1 ]
   bicenter n
   if n <= 10 or n >= 244
      print n & ": " & str unrooted[n][]
      if n = 10
         print "."
         print "."
      .
   .
.
