see "Degree  " +  "|" + "           Multifactorials 1 to 10" + nl
see copy("-", 52) + nl
for d = 1 to 5
    see "" + d + "       " + "| "
    for n = 1 to 10
        see "" + multiFact(n, d) + " "
    next
    see nl
next

func multiFact n, degree
     fact = 1
     for i = n to 2 step -degree
         fact = fact * i
     next
     return fact
