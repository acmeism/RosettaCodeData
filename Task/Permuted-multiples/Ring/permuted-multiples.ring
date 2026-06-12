load "stdlib.ring"

see "working..." + nl
see "Permuted multiples are:" + nl
per = list(6)
perm = list(6)

for n = 1 to 1000000
    for x = 2 to 6
        perm[x] = []
    next
    perStr = list(6)
    for z = 2 to 6
        per[z] = n*z
        perStr[z] = string(per[z])
        for m = 1 to len(perStr[z])
            add(perm[z],perStr[z][m])
        next
    next
    for y = 2 to 6
        perm[y] = sort(perm[y])
        perStr[y] = list2str(perm[y])
        perStr[y] = substr(perStr[y],nl,"")
    next

    if perStr[2] = perStr[3] and perStr[2] = perStr[4] and perStr[2] = perStr[5] and perStr[2] = perStr[6]
       see "n   = " + n + nl
       see "2*n = " + (n*2) + nl
       see "3*n = " + (n*3) + nl
       see "4*n = " + (n*4) + nl
       see "5*n = " + (n*5) + nl
       see "6*n = " + (n*6) + nl
       exit
    ok
next

see "done..." + nl
