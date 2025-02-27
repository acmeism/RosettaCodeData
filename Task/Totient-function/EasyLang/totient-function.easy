fastfunc totient n .
   tot = n
   i = 2
   while i <= sqrt n
      if n mod i = 0
         while n mod i = 0 : n = n div i
         tot -= tot div i
      .
      if i = 2 : i = 1
      i += 2
   .
   if n > 1 : tot -= tot div n
   return tot
.
numfmt 0 3
print "  N Prim Phi"
for n = 1 to 25
   tot = totient n
   x$ = "    "
   if n - 1 = tot : x$ = " x  "
   print n & x$ & tot
.
print ""
for n = 1 to 100000
   tot = totient n
   if n - 1 = tot : cnt += 1
   if n = 100 or n = 1000 or n = 10000 or n = 100000
      print n & " - " & cnt & " primes"
   .
.
