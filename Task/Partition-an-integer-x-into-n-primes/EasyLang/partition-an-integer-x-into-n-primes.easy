maxn = 100000
len sieve[] maxn
global prim[] .
proc mksieve . .
   max = sqrt len sieve[]
   for d = 2 to max
      if sieve[d] = 0
         for i = d * d step d to len sieve[]
            sieve[i] = 1
         .
      .
   .
   for n = 2 to len sieve[]
      if sieve[n] = 0
         prim[] &= n
      .
   .
.
mksieve
proc find n k start . found res[] .
   found = 0
   if k = 0
      if n = 0
         res[] = [ ]
         found = 1
      .
      return
   .
   for i = start to len prim[]
      p = prim[i]
      if p > n
         return
      .
      find (n - p) (k - 1) (i + 1) found r[]
      if found = 1
         swap res[] r[]
         res[] &= p
         return
      .
   .
   print "error: need more primes"
.
test[][] = [ [ 99809 1 ] [ 18 2 ] [ 19 3 ] [ 20 4 ] [ 2017 24 ] [ 22699 1 ] [ 22699 2 ] [ 22699 3 ] [ 22699 4 ] [ 40355 3 ] ]
for i to len test[][]
   find test[i][1] test[i][2] 1 f res[]
   write test[i][1] & "(" & test[i][2] & ") = "
   if f = 1
      for j = len res[] downto 2
         write res[j] & " + "
      .
      print res[1]
   else
      print "not possible"
   .
.
