see "Mersenne Primes :" + nl
for p = 2 to 18
    if lucasLehmer(p) see "M"  + p + nl ok
next

func lucasLehmer p
     i = 0 mp = 0 sn = 0
     if p = 2 return true ok
     if (p and 1) = 0 return false ok
     mp = pow(2,p) - 1
     sn = 4
     for i = 3 to p
         sn = pow(sn,2) - 2
         sn -= (mp * floor(sn / mp))
     next
     return (sn=0)
