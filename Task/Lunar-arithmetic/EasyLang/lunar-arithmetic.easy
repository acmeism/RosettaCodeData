func luadd a b .
   e = 1
   while a > 0 or b > 0
      d = higher (a mod 10) (b mod 10)
      a = a div 10
      b = b div 10
      r += d * e
      e *= 10
   .
   return r
.
func lumul a0 b .
   e0 = 1
   while b > 0
      e = e0
      r = 0
      a = a0
      while a > 0
         d = lower (a mod 10) (b mod 10)
         a = a div 10
         r += d * e
         e *= 10
      .
      s = luadd s r
      b = b div 10
      e0 *= 10
   .
   return s
.
tests[][] = [ [ 976 348 ] [ 23 321 ] [ 232 35 ] [ 123 32192 415 8 ] ]
for i to len tests[][]
   s = 0
   p = 9
   for h in tests[i][]
      s = luadd s h
      p = lumul p h
   .
   print "🌙+ " & tests[i][] & " -> " & s
   print "🌙* " & tests[i][] & " -> " & p
   print ""
.
print "First 20 distinct 🌙 even numbers:"
n = 1
while len nums[] < 20
   r = lumul n 2
   h = -1
   for h in nums[]
      if h = r : break 1
   .
   if h = -1 : nums[] &= r
   n += 1
.
for h in nums[] : write h & " "
print ""
print ""
print "First 20 🌙 square numbers:"
for i to 20
   write lumul i i & " "
.
print ""
print ""
print "First 20 🌙 factorial numbers:"
fac = 1
for i to 20
   fac = lumul fac i
   write fac & " "
.
print ""
print ""
h = 0
i = 1
repeat
   h = lumul i i
   until h < hp
   i += 1
   hp = h
.
print "First number whose 🌙 square is smaller than the previous: " & i
