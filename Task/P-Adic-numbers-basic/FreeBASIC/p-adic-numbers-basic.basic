' ***********************************************
'subject: convert two rationals to p-adic numbers,
'         add them up and show the result.
'tested : FreeBasic 1.07.0


'you can change this:

const emx = 64
'exponent maximum

const dmx = 100000
'approximation loop maximum


'better not change
'------------------------------------------------
const amx = 1048576
'argument maximum

const Pmax = 32749
'max. prime < 2^15


type ratio
   as longint a, b
end type

type padic
declare function r2pa (byref q as ratio, byval sw as integer) as integer
'convert q = a/b to p-adic number, set sw to print
declare sub printf (byval sw as integer)
'print expansion, set sw to print rational
declare sub crat ()
'rational reconstruction

declare sub add (byref a as padic, byref b as padic)
'let self:= a + b
declare sub cmpt (byref a as padic)
'let self:= complement_a

declare function dsum () as long
'weighted digit sum

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
'convert rational a/b to p-adic number
function padic.r2pa (byref q as ratio, byval sw as integer) as integer
dim as longint a = q.a, b = q.b
dim as long r, s, b1
dim i as integer
r2pa = 0

   if b = 0 then return 1
   if b < 0 then b = -b: a = -a
   if abs(a) > amx or b > amx then return -1
   if p < 2 or k < 1 then return 1

   'max. short prime
   p = min(p, Pmax)
   'max. array length
   k = min(k, emx - 1)

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

   i = 0
   'find -exponent of p in b
   do until b mod p
      b \= p: i -= 1
   loop

   s = 0
   r = b mod p
   'modular inverse for small p
   for b1 = 1 to p1
      s += r
      if s > p1 then s -= p
      if s = 1 then exit for
   next b1

   if b1 = p then
      print "r2pa: impossible inverse mod"
      return -1
   end if

   v = emx
   do
      'find exponent of p in a
      do until a mod p
         a \= p: i += 1
      loop

      'valuation
      if v = emx then v = i

      'upper bound
      if i >= emx then exit do
      'check precision
      if (i - v) > k then exit do

      'next digit
      d(i) = a * b1 mod p
      if d(i) < 0 then d(i) += p

      'remainder - digit * divisor
      a -= d(i) * b
   loop while a
end function

'------------------------------------------------
'Horner's rule
function padic.dsum () as long
dim as integer i, t = min(v, 0)
dim as long r, s = 0

   for i = k - 1 + t to t step -1
      r = s: s *= p
      if r andalso s \ r - p then
        'overflow
         s = -1: exit for
      end if
      s += d(i)
   next i

return s
end function

#macro pint(cp)
   for j = k - 1 + v to v step -1
      if cp then exit for
   next j
   fl = ((j - v) shl 1) < k
#endmacro

'rational reconstruction
sub padic.crat ()
dim as integer i, j, fl
dim as padic s = this
dim as long x, y

   'denominator count
   for i = 1 to dmx
      'check for integer
      pint(s.d(j))
      if fl then fl = 0: exit for

      'check negative integer
      pint(p1 - s.d(j))
      if fl then exit for

      'repeatedly add self to s
      s.add(s, this)
   next i

   if fl then s.cmpt(s)

   'numerator: weighted digit sum
   x = s.dsum: y = i

   if x < 0 or y > dmx then
      print "crat: fail"

   else
      'negative powers
      for i = v to -1
         y *= p: next

      'negative rational
      if fl then x = -x

      print x;
      if y > 1 then print "/";str(y);
      print
   end if
end sub


'print expansion
sub padic.printf (byval sw as integer)
dim as integer i, t = min(v, 0)

   for i = k - 1 + t to t step -1
      print d(i);
      if i = 0 andalso v < 0 then print ".";
   next i
   print

   'rational approximation
   if sw then crat
end sub

'------------------------------------------------
'carry
#macro cstep(dt)
   if c > p1 then
      dt = c - p: c = 1
   else
      dt = c: c = 0
   end if
#endmacro

'let self:= a + b
sub padic.add (byref a as padic, byref b as padic)
dim i as integer, r as padic
dim as long c = 0
with r
  .v = min(a.v, b.v)

   for i = .v to k +.v
      c += a.d(i) + b.d(i)
      cstep(.d(i))
   next i
end with
this = r
end sub

'let self:= complement_a
sub padic.cmpt (byref a as padic)
dim i as integer, r as padic
dim as long c = 1
with r
  .v = a.v

   for i = .v to k +.v
      c += p1 - a.d(i)
      cstep(.d(i))
   next i
end with
this = r
end sub


'main
'------------------------------------------------
dim as integer sw
dim as padic a, b, c
dim q as ratio

width 64, 30
cls

'rational reconstruction
'depends on the precision -
'until the dsum-loop overflows.
data 2,1, 2,4
data 1,1

data 4,1, 2,4
data 3,1

data 4,1, 2,5
data 3,1

' 4/9 + O(5^4)
data 4,9, 5,4
data 8,9

data 26,25, 5,4
data -109,125

data 49,2, 7,6
data -4851,2

data -9,5, 3,8
data 27,7

data 5,19, 2,12
data -101,384

'two 'decadic' pairs
data 2,7, 10,7
data -1,7

data 34,21, 10,9
data -39034,791

'familiar digits
data 11,4, 2,43
data 679001,207

data -8,9, 23,9
data 302113,92

data -22,7, 3,23
data 46071,379

data -22,7, 32749,3
data 46071,379

data 35,61, 5,20
data 9400,109

data -101,109, 61,7
data 583376,6649

data -25,26, 7,13
data 5571,137

data 1,4, 7,11
data 9263,2837

data 122,407, 7,11
data -517,1477

'more subtle
data 5,8, 7,11
data 353,30809

data 0,0, 0,0


print
do
   read q.a,q.b, p,k

   sw = a.r2pa(q, 1)
   if sw = 1 then exit do
   a.printf(0)

   read q.a,q.b

   sw or= b.r2pa(q, 1)
   if sw = 1 then exit do
   if sw then continue do
   b.printf(0)

   c.add(a, b)
   print "+ ="
   c.printf(1)

   print : ?
loop

system
