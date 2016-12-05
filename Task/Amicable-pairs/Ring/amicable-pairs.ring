size = 18500
for n = 1 to size
    m = amicable(n)
    if m>n and amicable(m)=n
       see "" + n + " and " + m + nl ok
next
see "OK" + nl

func amicable nr
     sum = 1
     for d = 2 to sqrt(nr)
         if nr % d = 0
            sum = sum + d
            sum = sum + nr / d ok
     next
     return sum
