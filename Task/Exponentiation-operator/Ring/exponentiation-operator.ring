see "11^5 = " + ipow(11, 5) + nl
see "pi^3 = " + fpow(3.14, 3) + nl

func ipow a, b
     p2 = 1
     for i = 1 to 32
         p2 *= p2
         if b < 0  p2 *= a ok
         b = b << 1
     next
     return p2

func fpow a, b
     p = 1
     for i = 1 to 32
         p *= p
         if b < 0  p *= a ok
         b = b << 1
     next
     return p
