see "working..." + nl
see "Minimum number of cells after, before, above and below NxN squares:" + nl
row = 0
cellsMin = []

for n = 1 to 10
    for m = 1 to 10
        cells = []
        add(cells,m-1)
        add(cells,10-m)
        add(cells,n-1)
        add(cells,10-n)
        min = min(cells)
        add(cellsMin,min)
    next
next

ind = 100
for n = 1 to ind
    row++
    see "" + cellsMin[n] + " "
    if row%10 = 0
       see nl
    ok
next

see "done..." + nl
