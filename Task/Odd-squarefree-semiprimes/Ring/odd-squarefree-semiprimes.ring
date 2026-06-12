load "stdlib.ring" # for isprime() function
? "working..." + nl + "Odd squarefree semiprimes are:"

limit = 1000 Prim = []

# create table of prime numbers from 3 to 1000 / 3
pr = []
for n = 3 to 1000 / 3
    if isprime(n) Add(pr,n) ok
next pl = len(pr)

# calculate upper limit for n
for nlim = 1 to pl
    if pr[nlim] * pr[nlim] > limit exit ok
next nlim--

# add items to result list and sort
for n = 1 to nlim
    for m = n + 1 to pl
        amt = pr[n] * pr[m]
        if amt > limit exit ok
        add(Prim, amt)
    next
next Prim = sort(Prim)

# display results
for n = 1 to len(Prim)
    see sf(Prim[n], 4) + " "
    if n % 20 = 0 see nl ok
next n--

? nl + nl + "Found " + n + " Odd squarefree semiprimes." + nl + "done..."

# a very plain string formatter, intended to even up columnar outputs
def sf x, y
    s = string(x) l = len(s)
    if l > y y = l ok
    return substr("          ", 11 - y + l) + s
