see "working..." +nl
see "Steady squatres under 10.000 are:" + nl
limit = 10000

for n = 1 to limit
    nstr = string(n)
    len = len(nstr)
    square = pow(n,2)
    rn = right(string(square),len)
    if nstr = rn
       see "" + n + " -> " + square + nl
    ok
next

see "done..." +nl
