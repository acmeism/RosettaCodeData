load "stdlib.ring" # for isprime() function
? "working..." + nl + "Frobenius numbers are:"

# create table of prime numbers between 2 and 101 inclusive
Frob = [2]
for n = 3 to 101
    if isprime(n) Add(Frob,n) ok
next

m = 1
for n = 2 to len(Frob)
    fr = Frob[n] * Frob[m] - Frob[n] - Frob[m]
    see sf(fr, 4) + " "
    if m % 5 = 0 see nl ok
    m = n
next

? nl + nl + "Found " + (m-1) + " Frobenius numbers" + nl + "done..."

# a very plain string formatter, intended to even up columnar outputs
def sf x, y
    s = string(x) l = len(s)
    if l > y y = l ok
    return substr("          ", 11 - y + l) + s
