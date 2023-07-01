# Project : Continued fraction

see "SQR(2) = " + contfrac(1, 1, "2", "1") + nl
see "        e = " + contfrac(2, 1, "n", "n") + nl
see "       PI = " + contfrac(3, 1, "6", "(2*n+1)^2") + nl

func contfrac(a0, b1, a, b)
        expr = ""
        n = 0
        while len(expr) < (700 - n)
                 n = n + 1
                 eval("temp1=" + a)
                 eval("temp2=" + b)
                 expr = expr + string(temp1) + char(43) + string(temp2) + "/("
        end
        str = copy(")",n)
        eval("temp3=" + expr + "1" + str)
        return a0 + b1 / temp3
