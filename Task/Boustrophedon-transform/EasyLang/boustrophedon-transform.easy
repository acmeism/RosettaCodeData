cache[][] = [ ]
a[] = [ ]
#
func T k n .
   if n = 1 : return a[k]
   if cache[k][n] = 0
      cache[k][n] = T k (n - 1) + T (k - 1) (k - n + 1)
   .
   return cache[k][n]
.
#
proc boustrophedon .
   k = len a[]
   cache[][] = [ ]
   len cache[][] k
   for i to k : len cache[i][] k
   b[] &= a[1]
   for n = 2 to k : b[] &= T n n
   print b[]
.
len a[] 15
print "1 followed by 0's:"
a[1] = 1
boustrophedon
#
print "\nAll 1's:"
proc mkall1 &a[] n .
   a[] = [ ]
   while len a[] <> n : a[] &= 1
.
mkall1 a[] 15
boustrophedon
#
print "\nAlternating 1, -1"
proc mkalt &a[] n .
   a[] = [ ]
   h = 1
   while len a[] <> n
      a[] &= h
      h *= -1
   .
.
mkalt a[] 15
boustrophedon
#
print "\nPrimes:"
func isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 1
   .
   return 1
.
proc mkprimes &a[] n .
   a[] = [ ]
   i = 2
   while len a[] <> n
      if isprim i = 1 : a[] &= i
      i += 1
   .
.
mkprimes a[] 15
boustrophedon
#
print "\nFibonacci numbers:"
proc mkfibon &a[] n .
   a[] = [ 1 ]
   val = 1
   while len a[] <> n
      h = prev + val
      prev = val
      val = h
      a[] &= val
   .
.
mkfibon a[] 15
boustrophedon
print "\nFactorials:"
proc mkfact &a[] n .
   a[] = [ ]
   f = 1
   while len a[] <> n
      a[] &= f
      f *= len a[]
   .
.
mkfact a[] 15
boustrophedon
