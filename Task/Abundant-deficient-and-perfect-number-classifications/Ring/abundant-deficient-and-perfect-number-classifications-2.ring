a = 0
d = 0
p = 0
for n = 1 to 20000
    Pn = sumDivs(n)
    if Pn > n a = a + 1 ok
    if Pn < n d = d + 1 ok
    if Pn = n p = p + 1 ok
next
see "Abundant : " + a + nl
see "Deficient: " + d + nl
see "Perfect  : " + p + nl

func sumDivs (n)
    if n < 2 return 0
    else
        sum = 1
        sr  = sqrt(n)
        for d = 2 to sr
            if n % d = 0
               sum = sum + d
               if d != sr sum = sum + n / d ok
            ok
        next
        return sum
    ok
