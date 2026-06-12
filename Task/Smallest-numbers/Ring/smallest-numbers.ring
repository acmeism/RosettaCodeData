load "bignumber.ring"

decimals(0)
see "working..." + nl
see "Smallest number k > 0 such that the decimal expansion of k^k contains n are:" + nl

row = 0
limit1 = 50
limit2 = 30

for n = 0 to limit1
    strn = string(n)
    for m = 1 to limit2
        powm = pow(m,m)
        ind = substr(powm,strn)
        if ind > 0
           exit
        ok
    next
    row = row + 1
    see "" + m + " "
    if row%10 = 0
       see nl
    ok
next

see nl + "done..." + nl

func pow(num1,num2)
     num1 = string(num1)
     num2 = string(num2)
     return FuncPower(num1,num2)
