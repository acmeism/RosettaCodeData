#Aamrun, 5th October 2021

from random import seed,randint
from datetime import datetime

seed(str(datetime.now()))

largeNum = [randint(1,9)]

for i in range(1,1000):
    largeNum.append(randint(0,9))

maxNum,minNum = 0,99999

for i in range(0,994):
    num = int("".join(map(str,largeNum[i:i+5])))
    if num > maxNum:
        maxNum = num
    elif num < minNum:
        minNum = num

print("Largest 5-adjacent number found ", maxNum)
print("Smallest 5-adjacent number found ", minNum)
