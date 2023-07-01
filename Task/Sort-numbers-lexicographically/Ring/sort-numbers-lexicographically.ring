# Project : Lexicographical numbers

lex = 1:13
strlex = list(len(lex))
for n = 1 to len(lex)
     strlex[n] = string(lex[n])
next
strlex = sort(strlex)
see "Lexicographical numbers = "
showarray(strlex)

func showarray(vect)
        see "["
        svect = ""
        for n = 1 to len(vect)
              svect = svect + vect[n] + ","
        next
        svect = left(svect, len(svect) - 1)
        see svect + "]" + nl
