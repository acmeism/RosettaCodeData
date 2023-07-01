' ***********************************************
'subject: Shanks's square form factorization:
'         ambiguous forms of discriminant 4N
'         give factors of N.
'tested : FreeBasic 1.08.1


'------------------------------------------------
const MxN = culngint(1) shl 62
'input maximum

const qx = (1 shl 5) - 1
'queue size

type arg
   'squfof arguments
   as ulong m, f
   as integer vb
end type

type bqf
   declare sub rho ()
   'reduce indefinite form
   declare function issq (byref r as ulong) as integer
   'return -1 if c is square, set r:= sqrt(c)
   declare sub qform (byref g as string, byval t as integer)
   'print binary quadratic form #t (a, 2b, c)

   as ulong rN, a, b, c
   as integer vb
end type

type queue
   declare sub enq (byref P as bqf)
   'enqueue P.c, P.b if appropriate
   declare function pro (byref P as bqf, byval r as ulong) as integer
   'return -1 if a proper square form is found

   as ulong a(qx), L, m
   as integer k, t
end type

'global variables
dim shared N as ulongint
'the number to split

dim shared flag as integer
'signal to end all threads

dim shared as ubyte q1024(1023), q3465(3464)
'quadratic residue tables


'------------------------------------------------
sub bqf.rho ()
dim as ulong q, t
   swap a, c
   'residue
   q = culng(rN + b) \ a
   t = b: b = q * a - b
   'pseudo-square
   c += q * (t - b)
end sub

'initialize form
#macro rhoin(F)
   F.rho : h = F.b
   F.c = (mN - h * h) \ F.a
#endmacro

function bqf.issq (byref r as ulong) as integer
if q1024(c and 1023) andalso q3465(c mod 3465) then
   '98.6% non-squares filtered
   r = culng(sqr(c))
   if r * r = c then return -1
end if
issq = 0
end function

sub bqf.qform (byref g as string, byval t as integer)
if vb = 0 then exit sub
dim as longint u = a, v = b, w = c
   if t and 1 then
      w = -w
   else
      u = -u
   end if
   v shl= 1
   print g;str(t);" = (";u;",";v;",";w;")"
end sub

'------------------------------------------------
#macro red(r, a)
   r = iif(a and 1, a, a shr 1)
   if m > 2 then
      r = iif(r mod m, r, r \ m)
   end if
#endmacro

sub queue.enq (byref P as bqf)
dim s as ulong
   red(s, P.c)
   if s < L then
      'circular queue
      k = (k + 2) and qx
      if k > t then t = k
      'enqueue P.b, P.c
      a(k) = P.b mod s
      a(k + 1) = s
   end if
end sub

function queue.pro (byref P as bqf, byval r as ulong) as integer
dim as integer i, sw
   'skip improper square forms
   for i = 0 to t step 2
      sw = (P.b - a(i)) mod r = 0
      sw and= a(i + 1) = r
      if sw then return 0
   next i
pro = -1
end function

'------------------------------------------------
sub squfof (byval ap as any ptr)
dim as arg ptr rp = cptr(arg ptr, ap)
dim as ulong L2, m, r, t, f = 1
dim as integer ix, i, j
dim as ulongint mN, h
'principal and ambiguous cycles
dim as bqf P, A
dim Q as queue

if (N and 1) = 0 then
   rp->f = 2 ' even N
   flag =-1: exit sub
end if

h = culngint(sqr(N))
if h * h = N then
   'N is square
   rp->f = culng(h)
   flag =-1: exit sub
end if

rp->f = 1
'multiplier
m = rp->m
if m > 1 then
   if (N mod m) = 0 then
      rp->f = m  ' m | N
      flag =-1: exit sub
   end if

   'check overflow m * N
   if N > (MxN \ m) then exit sub
end if
mN = N * m

r = int(sqr(mN))
'float64 fix
if culngint(r) * r > mN then r -= 1
P.rN = r
A.rN = r

P.vb = rp->vb
A.vb = rp->vb
'verbosity switch
if P.vb then print "r = "; r

Q.k = -2: Q.t = -1: Q.m = m
'Queue entry bounds
Q.L = int(sqr(r * 2))
L2 = Q.L * m shl 1

'principal form
P.b = r: P.c = 1
rhoin(P)
P.qform("P", 1)

ix = Q.L shl 2
for i = 2 to ix
   'search principal cycle

   if P.c < L2 then Q.enq(P)

   P.rho
   if (i and 1) = 0 andalso P.issq(r) then
      'square form found

      if Q.pro(P, r) then

         P.qform("P", i)
         'inverse square root
         A.b =-P.b: A.c = r
         rhoin(A): j = 1
         A.qform("A", j)

         do
            'search ambiguous cycle
            t = A.b
            A.rho: j += 1

            if A.b = t then
               'symmetry point
               A.qform("A", j)
               red(f, A.a)
               if f = 1 then exit do

               flag = -1
               'factor found
            end if
         loop until flag

      end if ' proper square
   end if ' square form

   if flag then exit for
next i

rp->f = f
end sub

'------------------------------------------------
data 2501
data 12851
data 13289
data 75301
data 120787
data 967009
data 997417
data 7091569
data 13290059
data 23515517
data 42854447
data 223553581
data 2027651281
data 11111111111
data 100895598169
data 1002742628021
data 60012462237239
data 287129523414791
data 9007199254740931
data 11111111111111111
data 314159265358979323
data 384307168202281507
data 419244183493398773
data 658812288346769681
data 922337203685477563
data 1000000000000000127
data 1152921505680588799
data 1537228672809128917
data 4611686018427387877
data 0

'main
'------------------------------------------------
const tx = 4
dim as double tim = timer
dim h(4) as any ptr
dim a(4) as arg
dim as ulongint f
dim as integer s, t

width 64, 30
cls

'tabulate quadratic residues
for t = 0 to 1540
   s = t * t
   q1024(s and 1023) =-1
   q3465(s mod 3465) =-1
next t

a(0).vb = 0
'set one verbosity switch only

a(0).m = 1
'multipliers
a(1).m = 3
a(2).m = 5
a(3).m = 7
a(4).m = 11

do
   print

   do : read N
   loop until N < MxN
   if N < 2 then exit do

   print "N = "; N

   flag = 0

   for t = 1 to tx + 1 step 2
      if t < tx then
         h(t) = threadcreate(@squfof, @a(t))
      end if

      squfof(@a(t - 1))
      f = a(t - 1).f

      if t < tx then
         threadwait(h(t))
         if f = 1 then f = a(t).f
      end if

      if f > 1 then exit for
   next t

   'assert
   if N mod f then f = 1

   if f = 1 then
      print "fail"
   else
      print "f = ";f;"  N/f = ";N \ f
   end if
loop

print "total time:"; csng(timer - tim); " s"
end
