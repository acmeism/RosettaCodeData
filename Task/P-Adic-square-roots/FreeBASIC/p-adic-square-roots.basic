' ***********************************************
'subject: p-adic square roots, Hensel lifting.
'tested : FreeBasic 1.07.0

'The root is squared, approximated by a
'rational, and compared with radicand a/b.


const emx = 48
'exponent maximum

const amx = 700000
'tentative argument maximum

'------------------------------------------------
const Mxd = cdbl(2)^53 - 1
'max. float64 integer

const Pmax = 32749
'max. prime < 2^15


type ratio
   as longint a, b
end type

type padic
declare function sqrt (byref q as ratio, byval sw as integer) as integer
'p-adic square root of q = a/b, set sw to print
declare sub printf (byval sw as integer)
'print expansion, set sw to print rational
declare function crat (byval sw as integer) as ratio
'rational reconstruction

declare sub cmpt (byref a as padic)
'let self:= complement_a
declare sub sqr (byref a as padic)
'let self:= a ^ 2

   as long d(-emx to emx - 1)
   as integer v
end type


'global variables
dim shared as long p1, p = 7
'default prime
dim shared as integer k = 11
'precision

#define min(a, b) iif((a) > (b), b, a)


'------------------------------------------------
'p-adic square root of g = a/b
function padic.sqrt (byref g as ratio, byval sw as integer) as integer
dim as longint a = g.a, b = g.b
dim as longint q, x, pk, pm
dim as long f1, r, s, t
dim i as integer, f as double
sqrt = 0

   if b = 0 then return 1
   if b < 0 then b = -b: a = -a
   if p < 2 or k < 1 then return 1

   'max. short prime
   p = min(p, Pmax)

   if sw then
      'echo numerator, denominator,
      print a;"/";str(b);" + ";
      'prime and precision
      print "O(";str(p);"^";str(k);")"
   end if

   'initialize
   v = 0
   p1 = p - 1
   for i = -emx to emx - 1
      d(i) = 0: next

   if a = 0 then return 0

   'valuation
   do until b mod p
      b \= p: v -= 1
   loop
   do until a mod p
      a \= p: v += 1
   loop

   if (v and 1) = 1 then
      'odd valuation
      print "non-residue mod"; p
      return -1
   end if

   'max. array length
   k = min(k + v, emx - 1)
   k -= v: v shr= 1

   if abs(a) > amx or b > amx then return -1

   if p = 2 then
      '1 / b = b (mod 8)
      'a / b = 1 (mod 8)
      t = a * b
      if (t and 7) - 1 then
         print "non-residue mod 8"
         return -1
      end if

   else
      'find root for small p
      for r = 1 to p1
         q = b * r * r - a
         if q mod p = 0 then exit for
      next r

      if r = p then
         print "non-residue mod"; p
         return -1
      end if

      'f'(r) = 2br
      t = b * r shl 1

      s = 0
      t mod= p
      'modular inverse for small p
      for f1 = 1 to p1
         s += t
         if s > p1 then s -= p
         if s = 1 then exit for
      next f1

      if f1 = p then
         print "impossible inverse mod"
         return -1
      end if
   end if

   'evaluate f(x)
   #macro evalf(x)
      f = b * x * cdbl(x / pk)
      f -= cdbl(a / pk)
      'overflow
      if f > Mxd then exit for
      q = clngint(f)
   #endmacro

   if p = 2 then
      'initialize
      x = 1
      d(v) = 1
      d(v + 1) = 0

      pk = 4
      for i = v + 2 to k - 1 + v
         pk shl= 1
         '2-power overflow
         if pk < 1 then exit for
         evalf(x)
         'next digit
         d(i) = iif(q and 1, 1, 0)
         'lift x
         x += d(i) * (pk shr 1)
      next i

   else
      '-1 / f'(x) mod p
      f1 = p - f1
      x = r
      d(v) = x

      pk = 1
      for i = v + 1 to k - 1 + v
         pm = pk: pk *= p
         if pk \ pm - p then exit for
         evalf(x)
         d(i) = q * f1 mod p
         if d(i) < 0 then d(i) += p
         x += d(i) * pk
      next i
   end if
   k = i - v

   if sw then print "lift:";x;" mod";p;"^";str(k)
end function

'------------------------------------------------
'rational reconstruction
function padic.crat (byval sw as integer) as ratio
dim as integer i, j, t = min(v, 0)
dim as longint s, pk, pm
dim as long q, x, y
dim as double f, h
dim r as ratio

   'weighted digit sum
   s = 0: pk = 1
   for i = t to k - 1 + v
      pm = pk: pk *= p

      if pk \ pm - p then
         'overflow
         pk = pm: exit for
      end if

      s += d(i) * pm '(mod pk)
   next i

   'lattice basis reduction
   dim as longint m(1) = {pk, s}
   dim as longint n(1) = {0, 1}
   'norm(v)^2
   h = cdbl(s) * s + 1
   i = 0: j = 1

   'Lagrange's algorithm
   do
      f = m(i) * (m(j) / h)
      f += n(i) * (n(j) / h)

      'Euclidean step
      q = int(f +.5)
      m(i) -= q * m(j)
      n(i) -= q * n(j)

      f = h
      h = cdbl(m(i)) * m(i)
      h += cdbl(n(i)) * n(i)
      'compare norms
      if h < f then
        'interchange vectors
         swap i, j
      else
         exit do
      end if
   loop

   x = m(j): y = n(j)
   if y < 0 then y = -y: x = -x

   'check determinant
   t = abs(m(i) * y - x * n(i)) = pk

   if t = 0 then
      print "crat: fail"
      x = 0: y = 1

   else
      'negative powers
      for i = v to -1
         y *= p: next

      if sw then
         print x;
         if y > 1 then print "/";str(y);
         print
      end if
   end if

   r.a = x: r.b = y
return r
end function


'print expansion
sub padic.printf (byval sw as integer)
dim as integer i, t = min(v, 0)

   for i = k - 1 + t to t step -1
      print d(i);
      if i = 0 andalso v < 0 then print ".";
   next i
   print

   'rational approximation
   if sw then crat(sw)
end sub

'------------------------------------------------
'let self:= complement_a
sub padic.cmpt (byref a as padic)
dim i as integer, r as padic
dim as long c = 1
with r
  .v = a.v

   for i = .v to k +.v
      c += p1 - a.d(i)
      'carry
      if c > p1 then
        .d(i) = c - p: c = 1
      else
        .d(i) = c: c = 0
      end if
   next i
end with
this = r
end sub

'let self:= a ^ 2
sub padic.sqr (byref a as padic)
dim as long ptr rp, ap = @a.d(a.v)
dim as longint q, c = 0
dim as integer i, j
dim r as padic
with r
  .v = a.v shl 1
   rp = @.d(.v)

   for i = 0 to k
      for j = 0 to i
         c += ap[j] * ap[i - j]
      next j
      'Euclidean step
      q = c \ p
      rp[i] = c - q * p
      c = q
   next i
end with
this = r
end sub


'main
'------------------------------------------------
dim as integer sw
dim as padic a, c
dim as ratio q, r

width 64, 30
cls

'   -7 + O(2^7)
data -7,1, 2,7
data 9,1, 2,8
data 17,1, 2,9
data 497,10496, 2,18
data 10496,497, 2,19

data -577215,664901, 3,23
data 15403,26685, 3,18

data -1,1, 5,8
data 86,25, 5,8
data 2150,1, 5,8

data 2,1, 7,8
data 11696,621467, 7,11
data -27764,11521, 7,11
data -27584,12953, 7,11

data -166420,135131, 11,11
data 14142,135623, 5,15
data -255,256, 257,3

data 0,0, 0,0


print
do
   read q.a,q.b, p,k

   sw = a.sqrt(q, 1)
   if sw = 1 then exit do
   if sw then ? : continue do

   print "sqrt +/-"
   print "...";
   a.printf(0)
   a.cmpt(a)
   print "...";
   a.printf(0)

   c.sqr(a)
   print "sqrt^2"
   print "   ";
   c.printf(0)
   r = c.crat(1)

   '{r = q}
   if q.a * r.b - r.a * q.b then
      print "fail: sqrt^2"
   end if

   print : ?
loop

end
