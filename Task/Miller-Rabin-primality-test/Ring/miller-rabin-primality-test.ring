# Project : Miller–Rabin primality test

see "Input a number: " give n
see "Input test: " give k

test =  millerrabin(n,k)
if test = 0
   see "Probably Prime" + nl
else
   see "Composite" + nl
ok

func millerrabin(n, k)
       if n = 2
          millerRabin = 0
          return millerRabin
       ok
       if n % 2 = 0 or n < 2
          millerRabin = 1
          return millerRabin
       ok
       d = n - 1
       s = 0
       while d % 2 = 0
               d = d / 2
               s = s + 1
       end
       while k > 0
               k = k - 1
               base = 2 + floor((random(10)/10)*(n-3))
               x = pow(base, d) % n
               if x != 1 and x != n-1
                  for r=1 to s-1
                      x = (x * x) % n
                      if x = 1
                         millerRabin = 1
                         return millerRabin
                      ok
                      if x = n-1
                         exit
                      ok
                  next
                  if x != n-1
                     millerRabin = 1
                     return millerRabin
                  ok
                ok
     end
