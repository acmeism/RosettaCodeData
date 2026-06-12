func[] add_poly p1[] p2[] .
   l1 = len p1[]
   l2 = len p2[]
   if l2 > l1 : len p1[] len p2[]
   for i = 1 to l2
      p1[i] += p2[i]
   .
   return p1[]
.
func[] mul_poly p1[] p2[] .
   m = len p1[]
   n = len p2[]
   len res[] m + n - 1
   for i = 1 to m
      for j = 1 to n
         res[i + j - 1] += p1[i] * p2[j]
      .
   .
   return res[]
.
func[] scal_mul p[] x .
   for e in p[] : r[] &= e * x
   return r[]
.
func[] scal_div p[] x .
   return scal_mul p[] (1 / x)
.
func eval_poly p[] x .
   res = p[$]
   for i = len p[] - 1 downto 1
      res = res * x + p[i]
   .
   return res
.
proc show_poly p[] .
   l = len p[]
   for i = l downto 1
      p = p[i]
      if i < l
         if p < 0
            write " - "
            p = -p
         else
            write " + "
         .
      .
      write p
      if i > 1
         write "x"
         if i > 2 : write "^" & i - 1
      .
   .
   print ""
.
func[] lagrange pts[][] .
   c = len pts[][]
   for i = 1 to c
      poly[] = [ 1 ]
      for j = 1 to c
         if i <> j
            poly[] = mul_poly poly[] [ -pts[j][1] 1 ]
         .
      .
      d = eval_poly poly[] pts[i][1]
      polys[][] &= scal_div poly[] d
   .
   res[] = [ 0 ]
   for i = 1 to c
      polys[i][] = scal_mul polys[i][] pts[i][2]
      res[] = add_poly res[] polys[i][]
   .
   return res[]
.
pts[][] = [ [ 1 1 ] [ 2 4 ] [ 3 1 ] [ 4 5 ] ]
lip[] = lagrange pts[][]
show_poly lip[]
