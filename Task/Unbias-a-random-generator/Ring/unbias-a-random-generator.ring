for n = 3 to 6
    biased = 0
    unb = 0
    for i = 1 to 10000
        biased += randN(n)
        unb += unbiased(n)
    next
    see "N = " + n + " : biased = " + biased/100  + "%, unbiased = " + unb/100 + "%" + nl
next

func unbiased nr
     while 1
           a = randN(nr)
           if a != randN(nr) return a ok
     end

func randN m
     m = (random(m) = 1)
     return m
