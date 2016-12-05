see longest("1267834", "1224533324") + nl

func longest a, b
     if a = "" or b = "" return "" ok
     if right(a, 1) = right(b, 1)
        lcs = longest(left(a, len(a) - 1), left(b, len(b) - 1)) + right(a, 1)
        return lcs
     else
        x1 = longest(a, left(b, len(b) - 1))
        x2 = longest(left(a, len(a) - 1), b)
        if len(x1) > len(x2)
           lcs = x1
           return lcs
        else
           lcs = x2
           return lcs ok ok
