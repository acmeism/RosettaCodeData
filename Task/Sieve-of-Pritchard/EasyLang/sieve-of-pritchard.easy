proc pritchard limit &primes[] .
   len members[] limit
   members[1] = 1
   steplength = 1
   prime = 2
   rtlimit = sqrt limit
   nlimit = 2
   primes[] = [ ]
   while prime <= rtlimit
      if steplength < limit
         for w to len members[]
            if members[w] = 1
               n = w + steplength
               while n <= nlimit
                  members[n] = 1
                  n += steplength
               .
            .
         .
         steplength = nlimit
      .
      np = 5
      mcpy[] = members[]
      for w to nlimit
         if mcpy[w] = 1
            if np = 5 and w > prime : np = w
            n = prime * w
            if n > nlimit : break 1
            members[n] = 0
         .
      .
      if np < prime : break 1
      primes[] &= prime
      if prime = 2
         prime = 3
      else
         prime = np
      .
      nlimit = lower (steplength * prime) limit
   .
   for i = 2 to len members[]
      if members[i] = 1 : primes[] &= i
   .
.
pritchard 150 p[]
print p[]
