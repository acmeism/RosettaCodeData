load "stdlib.ring"

? "working..."

c = 0
limit = 1000

? "Primes under " + limit + " with digits in nondecreasing order:"

for n = 1 to limit
    flag = 1
    strn = string(n)
    if isprime(n)
        for m = 1 to len(strn) - 1
            if strn[m] > strn[m + 1]
               flag = 0
               exit
            ok
        next
        if flag = 1
           see sf(n, 4) + " "
           c++ if c % 10 = 0 see nl ok
        ok
    ok
next

? nl + "Found " + c + " base 10 primes with digits in nondecreasing order"
? "done..."

# a very plain string formatter, intended to even up columnar outputs
def sf x, y
    s = string(x) l = len(s)
    if l > y y = l ok
    return substr("          ", 11 - y + l) + s
