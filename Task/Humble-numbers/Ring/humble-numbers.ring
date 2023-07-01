load "stdlib.ring"

limit = 10
numList = []

for n2 = 0 to limit
    for n3 = 0 to limit
        for n5 = 0 to limit
            for n7 = 0 to limit
                num = pow(2,n2) * pow(3,n3) * pow(5,n5) * pow(7,n7)
                add(numList,num)
            next
        next
    next
next

numList = sort(numList)

see "The first 50 Humble numbers: " + nl

for n = 1 to 50
    see "" + numList[n] + " "
next
