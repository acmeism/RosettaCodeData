func$ add a$ b$ .
   for i to higher len a$ len b$
      a = number substr a$ i 1
      b = number substr b$ i 1
      r = a + b + c
      c = r div 10
      r$ &= r mod 10
   .
   if c > 0 : r$ &= c
   return r$
.
#
len fibdist[] 9
proc mkfibdist .
   # generate 1000 fibonacci numbers as
   # (reversed) strings, because 53 bit
   # integers are too small
   #
   n = 1000
   prev$ = 0
   val$ = 1
   fibdist[1] = 1
   for i = 2 to n
      h$ = add prev$ val$
      prev$ = val$
      val$ = h$
      ind = number substr val$ len val$ 1
      fibdist[ind] += 1
   .
   for i to len fibdist[]
      fibdist[i] = fibdist[i] / n
   .
.
mkfibdist
#
len benfdist[] 9
proc mkbenfdist .
   for i to 9
      benfdist[i] = log10 (1 + 1.0 / i)
   .
.
mkbenfdist
#
numfmt 0 3
print "Actual Expected"
for i to 9
   print fibdist[i] & "   " & benfdist[i]
.
