# Bead Sort algorithm in Ring language
aList = [5, 3, 1, 7, 4, 1, 1, 20]
see "Original list: " + nl
showList(aList)

aList = beadSort(aList)

see "Sorted list: " + nl
showList(aList)

func beadSort aData
    nLen = len(aData)
    if nLen = 0 return aData ok

    # Find largest element (number of columns)
    nMax = aData[1]
    for x in aData
        if x > nMax nMax = x ok
    next

    # Initialize a matrix of beads (rows x columns)
    # In Ring, the lists are indexed from 1
    beads = list(nLen)
    for i = 1 to nLen
        beads[i] = list(nMax)
        for j = 1 to nMax
            if j <= aData[i]
                beads[i][j] = 1
            else
                beads[i][j] = 0
            ok
        next
    next

    # Simulate gravity: column-wise summation and redistribution
    for j = 1 to nMax
        sum = 0
        for i = 1 to nLen
            sum += beads[i][j]
            beads[i][j] = 0
        next

        # The beads "fall" to the bottom
        for i = nLen-sum+1 to nLen
            beads[i][j] = 1
        next
    next

    # Extract result from matrix
    aResult = list(nLen)
    for i = 1 to nLen
        rowSum = 0
        for j = 1 to nMax
            rowSum += beads[i][j]
        next
        aResult[i] = rowSum
    next

    return aResult

func showList aList
    for x in aList see "" + x + " " next
    see nl
