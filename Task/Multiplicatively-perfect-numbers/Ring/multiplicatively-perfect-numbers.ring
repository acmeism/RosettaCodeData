see "working..." + nl
see "Special numbers under 500:" + nl
limit = 500
Divisors = []
for n = 1 to limit
    pro = 1
    Divisors = []
    for m = 2 to ceil(n/2)
        if n % m = 0
           pro = pro * m
           add(Divisors,m)
        ok
    next
    str = ""
    if n = pro and len(Divisors) > 1
       for m = 1 to len(Divisors)
           str = str + Divisors[m] + " * "
           if m = len(Divisors)
              str = left(str,len(str)-2)
           ok
       next
       see "" + n + " = " + str + nl
    ok
next
see "done..." + nl
