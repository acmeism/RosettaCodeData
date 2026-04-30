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
   while len r[] > 1 and r[$] = 0 : len r[] -1
   return r[]
.
func[] bnadds a[] h .
   len r[] len a[]
   for i = 1 to len r[]
      h += a[i]
      r[i] = h mod 10000000
      h = h div 10000000
   .
   if h > 0 : r[] &= h
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
   while r[$] = 0 and len r[] > 1 : len r[] -1
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
func[] facts n .
   sqrtn = sqrt n
   f = 3
   while f <= sqrtn
      if n mod f = 0
         f[] &= f
         n = n div f
         sqrtn = sqrt n
      else
         f += 2
      .
   .
   f[] &= n
   return f[]
.
func[] bnsqrt n[] .
   len x[] (len n[] + 1) div 2
   x[$] = 1000000
   lastx[] = [ 0 ]
   while bncmp x[] lastx[] <> 0
      lastx[] = x[]
      res[][] = bndivmod n[] x[]
      sum[] = bnadd x[] res[1][]
      h = 0
      for i = len sum[] downto 1
         h = h * 10000000 + sum[i]
         sum[i] = h div 2
         h = h mod 2
      .
      while len sum[] > 1 and sum[$] = 0 : len sum[] -1
      swap x[] sum[]
      if bncmp x[] lastx[] >= 0 : return lastx[]
   .
   return x[]
.
func[] fermat n .
   ex[] = [ 2 ]
   for i to n : ex[] = bnmul ex[] ex[]
   return bnadds ex[] 1
.
func[][] factors fn[] .
   q[] = [ 3 ]
   lim[] = bnsqrt fn[]
   while bncmp q[] lim[] <= 0
      res[][] = bndivmod fn[] q[]
      if res[2][] = [ 0 ]
         f[][] &= q[]
         swap fn[] res[1][]
         lim[] = bnsqrt fn[]
      .
      q[] = bnadds q[] 2
   .
   if len f[][] >= 1 : f[][] &= fn[]
   return f[][]
.
for i = 0 to 10
   print "F(" & i & ") = " & str fermat i
.
print ""
for n = 5 to 6
   f[][] = factors fermat n
   write "Factors F(" & n & "): "
   for f[] in f[][] : write str f[] & " "
   print ""
.
