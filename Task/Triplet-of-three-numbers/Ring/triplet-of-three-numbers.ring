load "stdlib.ring"
see "working..." + nl
see "n  prime triplet" + nl
see "----------------" + nl
row = 0

limit = 6000

for n = 2 to limit-2
    bool1 = isprime(n-1)
    bool2 = isprime(n+3)
    bool3 = isprime(n+5)
    bool = bool1 and bool2 and bool3
    if bool
       row = row + 1
       see "" + n + ": (" + (n-1) + " " + (n+3) + " " + (n+5) + ")" + nl
    ok
next

see "Found " + row + " prime triplets" + nl
see "done..." + nl
