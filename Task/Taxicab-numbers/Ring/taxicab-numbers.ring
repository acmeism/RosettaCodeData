# Project : Taxicab numbers

num = 0
for n = 1 to 500000
    nr = 0
    tax = []
    for m = 1 to 75
        for p = m + 1 to 75
            if n = pow(m, 3) + pow(p, 3)
               add(tax, m)
               add(tax, p)
               nr = nr + 1
            ok
        next
    next
    if nr > 1
       num = num + 1
       see "" + num + " " + n + " => " + tax[1] + "^3 + " + tax[2] + "^3" + ", "
       see "" + tax[3] + "^3 +" + tax[4] + "^3" + nl
       if num = 25
          exit
       ok
    ok
next
see "ok" + nl
