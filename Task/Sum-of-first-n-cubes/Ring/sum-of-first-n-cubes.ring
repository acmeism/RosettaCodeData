see "working..." + nl
see "Sum of first n cubes:" + nl
row = 0
lenCubes = 49

for n = 0 to lenCubes
    sumCubes = 0
    for m = 1 to n
        sumCubes = sumCubes + pow(m,3)
    next
    row = row + 1
    see "" + sumCubes + " "
    if row%5 = 0
       see nl
    ok
next

see "Found " + row + " cubes" + nl
see "done..." + nl
