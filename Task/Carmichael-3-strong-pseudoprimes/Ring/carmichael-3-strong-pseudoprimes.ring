# Project : Carmichael 3 strong pseudoprimes
# Date    : 2017/11/29
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

see "The following are Carmichael munbers for p1 <= 61:" + nl
see "p1     p2      p3     product" + nl

for p = 2 to 61
    carmichael3(p)
next

func carmichael3(p1)
       if isprime(p1) = 0  return ok
       for h3 = 1 to p1 -1
            t1 = (h3 + p1) * (p1 -1)
            t2 = (-p1 * p1) % h3
            if t2 < 0
               t2 = t2 + h3
            ok
            for d = 1 to h3 + p1 -1
                 if t1 % d = 0 and t2 = (d % h3)
                   p2 = 1 + (t1 / d)
                   if isprime(p2) = 0
                      loop
                   ok
                   p3 = 1 + floor((p1 * p2 / h3))
                   if isprime(p3) = 0 or ((p2 * p3) % (p1 -1)) != 1
                      loop
                   ok
                   see "" + p1 + "       " + p2 + "      " + p3 + "    " + p1*p2*p3 + nl
                ok
            next
     next

func isprime(num)
       if (num <= 1) return 0 ok
       if (num % 2 = 0) and num != 2
          return 0
       ok
       for i = 3 to floor(num / 2) -1 step 2
           if (num % i = 0)
              return 0
           ok
       next
       return 1
