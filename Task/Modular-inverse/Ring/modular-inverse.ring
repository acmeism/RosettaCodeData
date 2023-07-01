see "42 %! 2017 = " + multInv(42, 2017) + nl

func multInv a,b
     b0 = b
     x0 = 0
     multInv = 1
     if b = 1 return 0 ok
     while a > 1
           q = floor(a / b)
           t = b
           b = a % b
           a = t
           t = x0
           x0 = multInv - q * x0
           multInv = t
     end
     if multInv < 0 multInv = multInv + b0 ok
     return multInv
