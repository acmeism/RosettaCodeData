for i = 1 to 20
    see "" + i + " = " + factors(i) + nl
next

func factors n
     f = ""
     if n = 1 return "1" ok
     p = 2
     while p <= n
           if (n % p) = 0
              f += string(p) + " x "
              n = n/p
           else p += 1 ok
     end
     return left(f, len(f) - 3)
