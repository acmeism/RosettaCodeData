see "the sums of divisors for  100  integers:" + nl
num = 0

for n = 1 to 100
    sum = 0
    for m = 1 to n
        if n%m = 0
           sum = sum + m
        ok
    next
    num = num + 1
    if num%10 = 1
       see nl
    ok
    see "" + sum + " "
next
