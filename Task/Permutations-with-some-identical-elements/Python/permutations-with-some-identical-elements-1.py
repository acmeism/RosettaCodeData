#Aamrun, 5th October 2021

from itertools import permutations

numList = [2,3,1]

baseList = []

for i in numList:
    for j in range(0,i):
        baseList.append(i)

stringDict = {'A':2,'B':3,'C':1}

baseString=""

for i in stringDict:
    for j in range(0,stringDict[i]):
        baseString+=i

print("Permutations for " + str(baseList) + " : ")
[print(i) for i in set(permutations(baseList))]

print("Permutations for " + baseString + " : ")
[print(i) for i in set(permutations(baseString))]
