load "stdlib.ring"

see "working..." + nl

row = 0
num = 0
limit = 500

for n = 1 to limit
    strm = ""
    strn = string(n)
    for m = len(strn) to 1 step -1
        strm = strm + strn[m]
    next
    strnum = number(strm)
    if isprime(n) and isprime(strnum)
       num = num + 1
       row = row + 1
       see "" + n + " "
       if row%10 = 0
          see nl
       ok
     ok
next

see nl + "found " + num + " primes" + nl
see "done..." + nl
