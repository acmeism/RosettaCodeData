#Aamrun, 5th October 2021

from itertools import permutations

for i in range(0,10):
    if i!=1:
        baseList = [1,1]
        baseList.append(i)
        [print(int(''.join(map(str,j)))) for j in sorted(set(permutations(baseList)))]
