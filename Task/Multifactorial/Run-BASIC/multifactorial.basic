print "Degree  " +  "|" + "           Multifactorials 1 to 10" + nl
print copy("-", 52) + nl
for d = 1 to 5
    print "" + d + "       " + "| "
    for n = 1 to 10
        print "" + multiFact(n, d) + " ";
    next
    print
next

function multiFact(n,degree)
     fact = 1
     for i = n to 2 step -degree
         fact = fact * i
     next
     multiFact = fact
 end function
