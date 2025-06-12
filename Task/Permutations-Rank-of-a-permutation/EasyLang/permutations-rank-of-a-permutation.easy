func[] init n .
   for i to n : r[] &= i - 1
   return r[]
.
func fac n .
   f = 1
   for i to n : f *= i
   return f
.
func[] perm n r .
   perm[] = init n
   fa = fac n
   for i = n downto 1
      fa /= i
      d = r div fa + 1
      r = r mod fa
      r[] &= perm[d]
      for j = d to i - 1
         perm[j] = perm[j + 1]
      .
   .
   return r[]
.
func rank n p[] .
   perm[] = init n
   fa = fac n
   for i = n downto 1
      fa /= i
      h = p[n - i + 1]
      d = 1
      while perm[d] <> h : d += 1
      r += fa * (d - 1)
      for j = d to i - 1
         perm[j] = perm[j + 1]
      .
   .
   return r
.
proc show .
   for i = 0 to 5
      h[] = perm 3 i
      print i & " -> " & h[] & " -> " & rank 3 h[]
   .
   print ""
   for i to 4
      r = random fac 12 - 1
      write r & " -> "
      h[] = perm 12 r
      write h[]
      print " -> " & rank 12 h[]
   .
.
show
