load "stdlib.ring"

row = 0
see "Strange numbers are:" + nl

for n = 100 to 500
    flag = 1
    str = string(n)
    for m = 1 to len(str)-1
        num1 = number(str[m])
        num2 = number(str[m+1])
        pr = fabs(num1-num2)
        if not isprime(pr)
           flag = 0
           exit
        ok
     next
     if flag = 1
        see str + " "
        row = row + 1
        if row % 10 = 0
           see nl
        ok
     ok
next
