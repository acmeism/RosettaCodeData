n=9
see "the square order is : " + n + nl
for i=1 to n
    for j = 1 to n
        x = (i*2-j+n-1) % n*n + (i*2+j-2) % n + 1
        see "" + x + " "
    next
    see nl
next
see "the magic number is : " + n*(n*n+1) / 2 + nl
