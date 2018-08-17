# Project : Factors of a Mersenne number

see "A factor of M929 is " + mersennefactor(929) + nl
see "A factor of M937 is " + mersennefactor(937) + nl

func mersennefactor(p)
       if not isprime(p)
         return -1
       ok
       for k = 1 to 50
            q = 2*k*p + 1
            if (q && 7) = 1 or (q && 7) = 7
               if isprime(q)
                  if modpow(2, p, q) = 1
                     return q
                  ok
               ok
            ok
       next
       return 0

func isprime(num)
       if (num <= 1) return 0 ok
       if (num % 2 = 0) and num != 2 return 0 ok
       for i = 3 to floor(num / 2) -1 step 2
            if (num % i = 0) return 0 ok
       next
       return 1

func modpow(x,n,m)
       i = n
       y = 1
       z = x
       while i > 0
               if i & 1
                  y = (y * z) % m
               ok
               z = (z * z) % m
               i = (i >> 1)
        end
        return y
