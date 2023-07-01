# Project : Munchausen numbers

limit = 5000

for n=1 to limit
    sum = 0
    msum = string(n)
    for m=1 to len(msum)
        ms = number(msum[m])
        sum = sum + pow(ms, ms)
    next
    if sum = n
       see n + nl
    ok
next
