'Subject: Solution of an m x n linear Diophantine system
'         A*x = b using LLL reduction.
'Ref.   : G. Havas, B. Majewski, K. Matthews,
'        'Extended gcd and Hermite normal form
'         algorithms via lattice basis reduction,'
'         Experimental Mathematics 7 (1998), no.2, pp.125-136
'Code   : FreeBasic 1.08.1

#define echo 1

Declare Sub Main (byval sw as integer)

'The complexity of the algorithm increases
'with alpha, as does the quality guarantee
'on the lattice basis vectors:
'alpha = aln / ald, 1/4 < alpha < 1
const aln = 80, ald = 81
'rows & columns
dim shared as integer m1, mn, nx, m, n
'column indices
dim shared as integer c1, c2

'Gram-Schmidt coefficients
'mu_rs = lambda_rs / d_s
'Br = d_r / d_r-1
dim shared as double la(any, any), d(any)
'work matrix
dim shared as double a(any, any)

'-------------------------------
'Part 1: driver, input and output
'---------------------------------

dim g as string
dim as integer i, sw

do
   print
   sw = 0
   do
      input ; " rows ", g
      if instr(g, "'") then
         print g
      else
         exit do
      end if
      sw or= instr(g, "const")
   loop
   n = val(g)
   if n < 1 then exit do

   input " cols ", g
   m = val(g)
   if m < 1 then
      for i = 1 to n: input g: next
      continue do
   end if

   'set indices and allocate
   if sw then sw = n - 1: n = 2: m += 2
   m1 = m + 1: mn = m1 + n: nx = mn + 1
   redim as double la(m, m), d(-1 to m)
   redim as double a(m, mn)

   cls
   Main sw
   print
loop
end


'input complex constant, read powers into A
Sub Inpconst (byval pr as integer)
dim as integer r, m2 = m1 + 1
dim as double p, q = 0, t, x, y
dim g as string

   input ; " a + bi:", g
   g = trim(g) + " + "
   r = instr(g, "+")
   x = val(mid(g, 1, r - 1))
   y = val(mid(g, r + 1))

   print x;
   if y then print " +";y;"*i";
   print

   'fudge factor 1
   a(0, m1) = 1
   'c ^ 0
   p = cdbl(10) ^ pr
   a(1, m1) = p
   'compute powers
   for r = 2 to m - 1
      t = p
      p = p * x - q * y
      q = t * y + q * x
      a(r, m1) = int(p + .5)
      a(r, m2) = int(q + .5)
   next r
End Sub

'input A and b
Function Inpsys () as integer
dim as integer i, j, k, r, s, t, sw = 0
dim g as string

   for r = 0 to n - 1
      g = str(r + 1)
      print " row A"; g; " and b"; g;
      input ; " ", g
      'reject all fractional coefficients
      sw or= instr(g, any "\./")

      'parse row
      i = 1: k = len(g)
      for s = 0 to m
         'locate next column separator (space or |)
         for t = -1 to 0
            j = i
            for i = j to k
               if (instr(" |", mid(g, i, 1)) = 0) = t then exit for
            next i
         next t
         a(s, m1 + r) = val(mid(g, j, i - j))
      next s: print
   next r

   if sw then print "illegal input"
Inpsys = sw
End Function

'print row r
#macro prow
   for s = 0 to mn
      if s = m1 then print " |";
      print space(p(s) - l(r, s) + 1); a(r, s);
   next s
#endmacro

'print matrix A(,)
Sub PrntM (byval sw as integer)
dim as integer l(m, mn), p(mn), k, r, s
dim g as string, q as double

for s = 0 to mn
   p(s) = 1: for r = 0 to m
      'store lengths and max. length in column
      'for pretty output
      l(r, s) = len(str(abs(a(r, s))))
      if l(r, s) > p(s) then p(s) = l(r, s)
   next r
next s

if sw then
   print "P | Hnf"

   'evaluate
   for r = 0 to m
      if a(r, mn) then k = r: exit for
   next r
   sw = a(k, mn) = 1
   for s = m1 to mn - 1
      sw and= a(k, s) = 0
   next s
   g = iif(sw,"  -solution","   inconsistent")
   for s = 0 to m - 1
      sw and= a(k, s) = 0
   next s
   if sw then g = "" ' trivial

   'Hnf and solution
   for r = m to k step -1
      prow
      print iif(r = k, g, "")
   next r
   'Null space with lengths squared
   for r = 0 to k - 1
      prow
      q = 0: for s = 0 to m - 1
         q += a(r, s) * a(r, s)
      next s
      print "   (";str(q);")"
   next r

else
   print "I | Ab~"

   for r = 0 to m
      prow
      print
   next r
end if
End Sub

'----------------------
'Part 2: HMM algorithm 4
'------------------------

'negate rows t
Sub Minus (byval t as integer)
dim as integer r, s
   for s = 0 to mn
      a(t, s) = -a(t, s)
   next s
   for r = 1 to m
      for s = 0 to r - 1
         if r = t or s = t then
            la(r, s) = -la(r, s)
         end if
      next s
   next r
End Sub

'LLL reduce rows k
Sub Reduce (byval k as integer, byval t as integer)
dim as integer s, sx
dim as double lk, q
   c1 = nx: c2 = nx
   'pivot elements Ab~ in rows t and k
   for s = m1 to mn
      if a(t, s) then c1 = s: exit for
   next s
   for s = m1 to mn
      if a(k, s) then c2 = s: exit for
   next s

   q = 0
   if c1 < nx then
      if a(t, c1) < 0 then Minus t
      q = int(a(k, c1) / a(t, c1)) ' floor
   else
      lk = la(k, t)
      if 2 * abs(lk) > d(t) then
         '2|lambda_kt| > d_t
         'not LLL-reduced yet
         q = int(lk / d(t) + .499) ' round
      end if
   end if

   if q then
      sx = iif(c1 = nx, m, mn)
      'reduce row k
      for s = 0 to sx
         a(k, s) -= q * a(t, s)
      next s
      la(k, t) -= q * d(t)
      for s = 0 to t - 1
         la(k, s) -= q * la(t, s)
      next s
   end if
End Sub

'exchange rows k and k-1
Sub Swop (byval k as integer)
dim as integer r, s, t = k - 1
dim as double db, lk, lr
   for s = 0 to mn
      swap a(k, s), a(t, s)
   next s
   for s = 0 to t - 1
      swap la(k, s), la(t, s)
   next s

   'update Gram coefficients
   'columns k, k-1 for r > k
   lk = la(k, t)
   db = (d(t - 1) * d(k) + lk * lk) / d(t)
   for r = k + 1 to m
      lr = la(r, k)
      la(r, k) = (d(k) * la(r, t) - lk * lr) / d(t)
      la(r, t) = (db * lr + lk * la(r, k)) / d(k)
   next r
   d(t) = db
End Sub

'main limiting sequence
Sub Main (byval sw as integer)
dim as integer i, k, t, tl = 0
dim as double db, lk

if sw then
   Inpconst sw
else
   if Inpsys then exit sub
end if
'augment Ab~ with column e_m
a(m, mn) = 1
'prefix standard basis
for i = 0 to m: a(i, i) = 1: next
'Gram sub-determinants
for i = -1 to m: d(i) = 1: next

if echo then PrntM 0

k = 1
while k <= m
   t = k - 1
   'partial size reduction
   Reduce k, t

   sw = (c1 = nx and c2 = nx)
   if sw then
      'zero rows k-1, k
      lk = la(k, t)
      'Lovasz condition
      'Bk >= (alpha - mu_kt^2) * Bt
      db = d(t - 1) * d(k) + lk * lk
      'not satisfied
      sw = db * ald < d(t) * d(t) * aln
   end if

   if sw or (c1 <= c2 and c1 < nx) then
      'test recommends a swap
      Swop k
      'decrease k
      if k > 1 then k -= 1
   else
      'complete size reduction
      for i = t - 1 to 0 step -1
         Reduce k, i
      next i
      'increase k
      k += 1
   end if

   tl += 1
wend

PrntM -1

print "loop"; tl
End Sub
