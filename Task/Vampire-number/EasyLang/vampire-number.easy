func dtally x .
   while x > 0
      t += bitshift 1 (x mod 10 * 6)
      x = x div 10
   .
   return t
.
proc fangs x . f[] .
   f[] = [ ]
   nd = floor log10 x + 1
   if nd mod 2 = 1
      return
   .
   nd = nd div 2
   lo = higher pow 10 (nd - 1) (x + pow 10 nd - 2) div (pow 10 nd - 1)
   hi = lower (x / lo) sqrt x
   t = dtally x
   for a = lo to hi
      b = x div a
      if a * b = x and (a mod 10 > 0 or b mod 10 > 0) and t = dtally a + dtally b
         f[] &= a
      .
   .
.
proc show_fangs x f[] . .
   write x & " "
   for f in f[]
      write " =  " & f & " x " & x div f
   .
   print ""
.
x = 1
while n < 25
   fangs x f[]
   if len f[] > 0
      n += 1
      write n & ": "
      show_fangs x f[]
   .
   x += 1
.
bigs[] = [ 16758243290880 24959017348650 14593825548650 ]
for x in bigs[]
   fangs x f[]
   if len f[] > 0
      show_fangs x f[]
   else
      print x & " is not vampiric"
   .
.
