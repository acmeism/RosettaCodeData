prod =  1
total =  0
x = 5
y = -5
z = -2
one =  1
three =  3
seven =  7

loopset = [[-three,pow(3,3),three],
           [-seven,seven,x],
           [555,550 - y,1],
           [22,-28,-three],
           [1927,1939,1],
           [x,y,z],
           [pow(11,x),pow(11,x) + one,1]]

for i=1 to len(loopset)
    f = loopset[i][1]
    t = loopset[i][2]
    s = loopset[i][3]
    for j=f to t step s
        total += fabs(j)
        if fabs(prod)<pow(2,27) and j!=0
           prod *= j
        ok
    next
next

see "total = " + total + nl
see "product = " + prod + nl
