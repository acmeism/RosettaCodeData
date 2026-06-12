load "stdlib.ring"

see "working..." + nl

row = 0
num = 0
limit1 = 200

for n = 1 to limit1
    flag = 1
    revNum = rever(string(n))
    revNum = number(revNum)
    for m = 1 to n/2
        revDiv = rever(String(m))
        revDiv = number(revDiv)
        if n%m = 0
           if revNum % revDiv = 0
              flag = 1
           else
              flag = 0
              exit
           ok
        ok
    next
    if flag = 1
       num = num + 1
       row = row + 1
       see "" + n + " "
       if row%10 = 0
          see nl
       ok
    ok
next

see nl + "Found " + num + " special divisors N that reverse(D) divides reverse(N) for all divisors D of N, where  N  <  200" + nl
see "done..." + nl

func rever(str)
     rev = ""
     for n = len(str) to 1 step -1
         rev = rev + str[n]
     next
     return rev
