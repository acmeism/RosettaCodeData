'subject: Elliptic curve digital signature algorithm,
'         toy version for small modulus N.
'tested : FreeBasic 1.05.0

'rational ec point
type epnt
   as longint x, y
end type
'elliptic curve parameters
type curve
   as long a, b
   as longint N
   as epnt G
   as longint r
end type
'signature pair
type pair
   as long a, b
end type

'longint for holding intermediate results,
'long variables in exgcd() for efficiency,
'maximum parameter size 2 * p.y (line 118)
'limits the modulus size to 30 bits.

'maximum modulus
const mxN = 1073741789
'max order G = mxN + 65536
const mxr = 1073807325
'symbolic infinity
const inf = -2147483647

'single global curve
dim shared as curve e
'point at infinity zerO
dim shared as epnt zerO
'impossible inverse mod N
dim shared as byte inverr


'return mod(v^-1, u)
Function exgcd (byval v as long, byval u as long) as long
dim as long q, t
dim as long r = 0, s = 1
if v < 0 then v += u

   while v
      q = u \ v
      t = u - q * v
      u = v: v = t
      t = r - q * s
      r = s: s = t
   wend

   if u <> 1 then
      print " impossible inverse mod N, gcd ="; u
      inverr = -1
   end if

exgcd = r
End Function

'return mod(a, N)
Function modn (byval a as longint) as longint
   a mod= e.N
   if a < 0 then a += e.N
modn = a
End Function

'return mod(a, r)
Function modr (byval a as longint) as longint
   a mod= e.r
   if a < 0 then a += e.r
modr = a
End Function


'return the discriminant of E
Function disc as long
dim as longint c, a = e.a, b = e.b
   c = 4 * modn(a * modn(a * a))
disc = modn(-16 * (c + 27 * modn(b * b)))
End Function

'return -1 if P = zerO
Function isO (byref p as epnt) as byte
isO = (p.x = inf and p.y = 0)
End Function

'return -1 if P is on curve E
Function ison (byref p as epnt) as byte
dim as long r, s
if not isO (p) then
   r = modn(e.b + p.x * modn(e.a + p.x * p.x))
   s = modn(p.y * p.y)
end if
ison = (r = s)
End Function


'full ec point addition
Sub padd (byref r as epnt, byref p as epnt, byref q as epnt)
dim as longint la, t

if isO (p) then r = q: exit sub
if isO (q) then r = p: exit sub

if p.x <> q.x then '                   R := P + Q
   t = p.y - q.y
   la = modn(t * exgcd (p.x - q.x, e.N))

else '                                 P = Q, R := 2P
   if (p.y = q.y) and (p.y <> 0) then
      t = modn(3 * modn(p.x * p.x) + e.a)
      la = modn(t * exgcd (2 * p.y, e.N))

   else
      r = zerO: exit sub '             P = -Q, R := O
   end if
end if

t = modn(la * la - p.x - q.x)
r.y = modn(la * (p.x - t) - p.y)
r.x = t: if inverr then r = zerO
End Sub

'R:= multiple kP
Sub pmul (byref r as epnt, byref p as epnt, byval k as long)
dim as epnt s = zerO, q = p

   while k
      if k and 1 then padd (s, s, q)
      if inverr then s = zerO: exit while
      k shr= 1: padd (q, q, q)
   wend
r = s
End Sub


'print point P with prefix f
Sub pprint (byref f as string, byref p as epnt)
dim as longint y = p.y

   if isO (p) then
      print f;" (0)"

   else
      if y > e.N - y then y -= e.N
      print f;" (";str(p.x);",";y;")"

   end if
End Sub

'initialize elliptic curve
Function ellinit (i() as long) as byte
dim as long a = i(0), b = i(1)
ellinit = 0: inverr = 0
   e.N = i(2)

if (e.N < 5) or (e.N > mxN) then exit function

   e.a = modn(a)
   e.b = modn(b)
   e.G.x = modn(i(3))
   e.G.y = modn(i(4))
   e.r = i(5)

if (e.r < 5) or (e.r > mxr) then exit function

print : ? "E: y^2 = x^3 + ";str(a);"x +";b;
print " (mod ";str(e.N);")"
pprint ("base point G", e.G)
print "order(G, E) ="; e.r

ellinit = -1
End Function


'signature primitive
Function signature (byval s as longint, byval f as long) as pair
dim as long c, d, u, u1
dim as pair sg
dim as epnt V

print : ? "signature computation"
do
   do
      u = 1 + int(rnd * (e.r - 1))
      pmul (V, e.G, u)
      c = modr(V.x)
   loop while c = 0

   u1 = exgcd (u, e.r)
   d = modr(u1 * (f + modr(s * c)))
loop while d = 0
print "one-time u ="; u
pprint ("V = uG", V)

sg.a = c: sg.b = d
signature = sg
End Function

'verification primitive
Function verify (byref W as epnt, byval f as long, byref sg as pair) as byte
dim as long c = sg.a, d = sg.b
dim as long t, c1, h1, h2
dim as longint h
dim as epnt V, V2
verify = 0

   'domain check
   t = (c > 0) and (c < e.r)
   t and= (d > 0) and (d < e.r)
   if not t then exit function

print : ? "signature verification"
   h = exgcd (d, e.r)
   h1 = modr(f * h)
   h2 = modr(c * h)
   print "h1,h2 ="; h1;",";h2
   pmul (V, e.G, h1)
   pmul (V2, W, h2)
   pprint ("h1G", V)
   pprint ("h2W", V2)
   padd (V, V, V2)
   pprint ("+ =", V)
   if isO (V) then exit function
   c1 = modr(V.x)
   print "c' ="; c1

verify = (c1 = c)
End Function

'digital signature on message hash f, error bit d
Sub ec_dsa (byval f as long, byval d as long)
dim as long i, s, t
dim as pair sg
dim as epnt W

   'parameter check
   t = (disc = 0)
   t or= isO (e.G)
   pmul (W, e.G, e.r)
   t or= not isO (W)
   t or= not ison (e.G)
   if t then goto errmsg

print : ? "key generation"
   s = 1 + int(rnd * (e.r - 1))
   pmul (W, e.G, s)
   print "private key s ="; s
   pprint ("public key W = sG", W)

   'next highest power of 2 - 1
   t = e.r: i = 1
   while i < 32
      t or= t shr i: i shl= 1
   wend
   while f > t
      f shr= 1: wend
   print : ? "aligned hash "; hex(f)

   sg = signature (s, f)
   if inverr then goto errmsg
   print "signature c,d ="; sg.a;",";sg.b

   if d > 0 then
      while d > t
         d shr= 1: wend
      f xor= d
      print : ? "corrupted hash "; hex(f)
   end if

   t = verify (W, f, sg)
   if inverr then goto errmsg
   if t then
      print "Valid" : ? "_____"
   else
      print "invalid" : ? "_______"
   end if

   exit sub

errmsg:
print "invalid parameter set"
print "_____________________"
End Sub


'main
dim as long d, f, t, eparm(5)
zerO.x = inf: zerO.y = 0
randomize timer

'Test vectors: elliptic curve domain parameters,
'short Weierstrass model y^2 = x^3 + ax + b (mod N)

'      a,   b,  modulus N, base point G, order(G, E), cofactor
data 355, 671, 1073741789, 13693, 10088, 1073807281
data   0,   7,   67096021,  6580,   779,   16769911 '   4
data  -3,   1,     877073,     0,     1,     878159
data   0,  14,      22651,    63,    30,        151 ' 151
data   3,   2,          5,     2,     1,          5

'ecdsa may fail if...
'the base point is of composite order
data   0,   7,   67096021,  2402,  6067,   33539822 '   2
'the given order is a multiple of the true order
data   0,   7,   67096021,  6580,   779,   67079644 '   1
'the modulus is not prime (deceptive example)
data   0,   7,     877069,     3, 97123,     877069
'fails if the modulus divides the discriminant
data  39, 387,      22651,    95,    27,      22651
data   0, 0, 0

'Digital signature on message hash f,
'set d > 0 to simulate corrupted data
f = &h789ABCDE : d = 0

do
   for t = 0 to 5
      read eparm(t): next

   if ellinit (eparm()) then
      ec_dsa (f, d)

   else
      exit do

   end if
loop

system
