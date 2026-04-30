func degree &p[] .
   for d = len p[] downto 1
      if p[d] <> 0 : return d - 1
   .
   return -1
.
proc vmul &a[] b .
   for i to len a[] : a[i] *= b
.
proc vsub &a[] &b[] .
   for i to len a[] : a[i] -= b[i]
.
proc pld nn[] dd[] &q[] &r[] .
   if degree dd[] < 0 : return
   q[] = [ ]
   repeat
      degn = degree nn[]
      dif = degn - degree dd[]
      until dif < 0
      len d[] dif
      for e in dd[] : d[] &= e
      for i to len nn[] - len d[] : d[] &= 0
      m = nn[degn + 1] / d[degn + 1]
      q[] &= m
      vmul d[] m
      vsub nn[] d[]
   .
   swap nn[] r[]
   for i to len q[] div 2 : swap q[i] q[$ - i + 1]
.
pld [ -42 0 -12 1 ] [ -3 1 ] q[] r[]
print q[] & r[]
pld [ -42 0 -12 1 ] [ -3 1 1 ] q[] r[]
print q[] & r[]
