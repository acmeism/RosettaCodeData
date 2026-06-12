#Aamrun, 4th October 2021

import sys

if len(sys.argv)!=2:
    print("Usage : python " + sys.argv[0] + " <whole number>")
    exit()

numLimit = int(sys.argv[1])

resultSet = {}

base = 1

while len(resultSet)!=numLimit:
    result = base**base

    for i in range(0,numLimit):
        if str(i) in str(result) and i not in resultSet:
            resultSet[i] = base

    base+=1

[print(resultSet[i], end=' ') for i in sorted(resultSet)]
