decimals(4)
for base = 2 to 5
    see "base " + string(base) + " : "
    for number = 0 to 9
        see "" + corput(number, base) + " "
    next
    see nl
next

func corput n, b
     vdc = 0
     denom = 1
     while n
           denom *= b
           rem = n % b
           n = floor(n/b)
           vdc += rem / denom
     end
     return vdc
