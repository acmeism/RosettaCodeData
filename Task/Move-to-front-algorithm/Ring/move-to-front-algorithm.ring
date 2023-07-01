# Project : Move-to-front algorithm

test("broood")
test("bananaaa")
test("hiphophiphop")

func encode(s)
        symtab = "abcdefghijklmnopqrstuvwxyz"
        res = ""
        for i=1 to len(s)
             ch = s[i]
             k = substr(symtab, ch)
             res = res + " " + (k-1)
             for j=k to 2 step -1
                  symtab[j] = symtab[j-1]
             next
             symtab[1] = ch
        next
        return res

func decode(s)
        s = str2list( substr(s, " ", nl) )
        symtab = "abcdefghijklmnopqrstuvwxyz"
        res = ""
        for i=1 to len(s)
             k = number(s[i]) + 1
             ch = symtab[k]
             res = res + " " + ch
             for j=k to 2 step -1
                   symtab[j] = symtab[j-1]
             next
             symtab[1] = ch
        next
        return right(res, len(res)-2)

func test(s)
        e = encode(s)
        d = decode(e)
        see "" + s + " => " + "(" + right(e, len(e) - 1) + ") " + " => " + substr(d, " ", "") + nl
