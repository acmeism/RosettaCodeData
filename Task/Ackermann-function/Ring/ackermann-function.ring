for m = 0 to 3
        for n = 0 to 4
                see "Ackermann(" + m + ", " + n + ") = " + Ackermann(m, n) + nl
         next
next

func Ackermann m, n
        if m > 0
           if n > 0
                return Ackermann(m - 1, Ackermann(m, n - 1))
            but n = 0
                return Ackermann(m - 1, 1)
            ok
        but m = 0
            if n >= 0
                return n + 1
            ok
        ok
Raise("Incorrect Numerical input !!!")
