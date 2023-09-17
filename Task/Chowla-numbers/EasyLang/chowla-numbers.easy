fastfunc chowla n .
   sum = 0
   i = 2
   while i * i <= n
      if n mod i = 0
         j = n div i
         if i = j
            sum += i
         else
            sum += i + j
         .
      .
      i += 1
   .
   return sum
.
proc sieve . c[] .
   i = 3
   while i * 3 <= len c[]
      if c[i] = 0
         if chowla i = 0
            j = 3 * i
            while j <= len c[]
               c[j] = 1
               j += 2 * i
            .
         .
      .
      i += 2
   .
.
proc commatize n . s$ .
   s$[] = strchars n
   s$ = ""
   l = len s$[]
   for i = 1 to len s$[]
      if i > 1 and l mod 3 = 0
         s$ &= ","
      .
      l -= 1
      s$ &= s$[i]
   .
.
print "chowla number from 1 to 37"
for i = 1 to 37
   print "  " & i & ": " & chowla i
.
proc main . .
   print ""
   len c[] 10000000
   count = 1
   sieve c[]
   power = 100
   i = 3
   while i <= len c[]
      if c[i] = 0
         count += 1
      .
      if i = power - 1
         commatize power p$
         commatize count c$
         print "There are " & c$ & " primes up to " & p$
         power *= 10
      .
      i += 2
   .
   print ""
   limit = 35000000
   count = 0
   i = 2
   k = 2
   kk = 3
   repeat
      p = k * kk
      until p > limit
      if chowla p = p - 1
         commatize p s$
         print s$ & " is a perfect number"
         count += 1
      .
      k = kk + 1
      kk += k
      i += 1
   .
   commatize limit s$
   print "There are " & count & " perfect mumbers up to " & s$
.
main
