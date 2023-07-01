see "working..." + nl
see "Own digits power sum for N = 3 to 9 inclusive:" + nl

for n = 3 to 9
    for curr = pow(10,n-1) to pow(10,n)-1
        sum = 0
        temp = curr
        while temp != 0
            dig = temp % 10
            temp = floor(temp/10)
            sum += pow(dig,n)
        end
        if sum = curr
           see "" + curr + nl
        ok
    next
next

see "done..." + nl
