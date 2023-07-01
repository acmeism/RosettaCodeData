T = [["79", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
     ["",   "H", "O", "L", "",  "M", "E", "S", "",  "R", "T"],
     ["3",  "A", "B", "C", "D", "F", "G", "I", "J", "K", "N"],
     ["7",  "P", "Q", "U", "V", "W", "X", "Y", "Z", ".", "/"]]

def straddle(s):
    return "".join(L[0]+T[0][L.index(c)] for c in s.upper() for L in T if c in L)

def unstraddle(s):
    s = iter(s)
    for c in s:
        if c in [T[2][0], T[3][0]]:
            i = [T[2][0], T[3][0]].index(c)
            n = T[2 + i][T[0].index(s.next())]
            yield s.next() if n == "/" else n
        else:
            yield T[1][T[0].index(c)]

O = "One night-it was on the twentieth of March, 1888-I was returning"
print "Encoded:", straddle(O)
print "Decoded:", "".join(unstraddle(straddle(O)))
