decimals(8)
see "monteCarlo(1000) = " + monteCarlo(1000) + nl
see "monteCarlo(10000) = " + monteCarlo(10000) + nl
see "monteCarlo(100000) = " + monteCarlo(100000) + nl

func monteCarlo t
     n=0
     for i = 1 to t
         if sqrt(pow(random(1),2) + pow(random(1),2)) <= 1 n += 1 ok
     next
     t = (4 * n) / t
     return t
