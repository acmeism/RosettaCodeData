row = 5
for i = 0 to row - 1
    col = 1
    see left("     ",row-i)
    for k = 0 to i
        see "" + col + " "
        col = col*(i-k)/(k+1)
    next
    see nl
next
