# Project : Integer roots

see root(3, 8)
see root(3, 9)
see root(4, 167)

func root(n, x)
       for nr = floor(sqrt(x)) to 1 step -1
            if pow(nr, n) <= x
               see nr + nl
               exit
            ok
       next
