nn = 10000000 - 1
len sieve[] nn
fastproc mksieve .
   max = sqrt len sieve[]
   for i = 2 to max : if sieve[i] = 0
      j = i * i
      while j <= len sieve[]
         sieve[j] = 1
         j += i
      .
   .
.
mksieve
#
func isprim num .
   if num < 2 : return 0
   return 1 - sieve[num]
.
proc safe_primes n shown safe &cnt .
   cnt = 0
   i = 2
   repeat
      if isprim i = 1 and isprim ((i - 1) div 2) = safe
         cnt += 1
         if shown <> 0
            write i & " "
            if cnt = shown
               print ""
               return
            .
         .
      .
      i += 1
      until i = n
   .
.
print "First 35 safe primes:"
safe_primes 0 35 1 cnt
for n in [ 1000000 10000000 ]
   safe_primes n 0 1 cnt
   print "There are " & cnt & " safe primes below " & n
.
print ""
print "First 40 unsafe primes:"
safe_primes 0 40 0 cnt
for n in [ 1000000 10000000 ]
   safe_primes n 0 0 cnt
   print "There are " & cnt & " safe primes below " & n
.
