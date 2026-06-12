load "stdlib.ring"

decimals(0)
see "working..." + nl
see "Smallest power of 6 whose decimal expansion contains n:" + nl

num = 0
limit = 200

for n = 1 to 21
    strn = string(n)
    for m = 0 to limit
        strpow = string(pow(6,m))
        ind = substr(strpow,strn)
        if ind > 0
           see "" + n + ". " + "6^" + m + " = " + strpow + nl
           exit
        ok
    next
next

see "done..." + nl
