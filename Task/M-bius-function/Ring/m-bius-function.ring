mobStr = "      . "

for i = 1 to 200
    if mobius(i) >= 0
       mobStr + = " "
    ok
    temp = string(mobius(i))
    if left(temp,2) = "-0"
       temp = right(temp,len(temp)-1)
    ok
    mobStr += temp + " "
    if i % 10 = 9
        see mobStr + nl
        mobStr = "     "
    ok
next

func mobius(n)
     if n = 1
        return 1
     ok
     for d = 2 to ceil(sqrt(n))
         if n % d = 0
            if n % (d*d) = 0
               return 0
            ok
            return -mobius(n/d)
         ok
     next
     return -1
