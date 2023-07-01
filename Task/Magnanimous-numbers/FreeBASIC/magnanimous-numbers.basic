#include "isprime.bas"

dim as uinteger magn(0 to 399), i, n=10, j
dim as string ns, lefty, righty
for i = 0 to 9
    magn(i) = i    'all single digit ints are magnanimous by definition
next i

while i<400
    n += 1
    ns = str(n)
    for j = 1 to len(ns)-1
        lefty = left(ns, j)
        righty = right(ns, len(ns)-j)
        if not isprime( val(lefty) + val(righty) ) then continue while
    next j
    magn(i) = n
    i+=1
wend

for i=0 to 44
    print i+1,magn(i)
next i

for i=240 to 249
    print i+1,magn(i)
next i

for i=390 to 399
    print i+1,magn(i)
next i
