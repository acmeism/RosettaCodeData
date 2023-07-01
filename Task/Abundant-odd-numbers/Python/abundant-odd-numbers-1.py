#!/usr/bin/python
# Abundant odd numbers - Python

oddNumber  = 1
aCount  = 0
dSum  = 0

from math import sqrt

def divisorSum(n):
    sum = 1
    i = int(sqrt(n)+1)

    for d in range (2, i):
        if n % d == 0:
            sum += d
            otherD = n // d
            if otherD != d:
                sum += otherD
    return sum

print ("The first 25 abundant odd numbers:")
while aCount  < 25:
    dSum  = divisorSum(oddNumber )
    if dSum  > oddNumber :
        aCount  += 1
        print("{0:5} proper divisor sum: {1}". format(oddNumber ,dSum ))
    oddNumber  += 2

while aCount  < 1000:
    dSum  = divisorSum(oddNumber )
    if dSum  > oddNumber :
        aCount  += 1
    oddNumber  += 2
print ("\n1000th abundant odd number:")
print ("    ",(oddNumber - 2)," proper divisor sum: ",dSum)

oddNumber  = 1000000001
found  = False
while not found :
    dSum  = divisorSum(oddNumber )
    if dSum  > oddNumber :
        found  = True
        print ("\nFirst abundant odd number > 1 000 000 000:")
        print ("    ",oddNumber," proper divisor sum: ",dSum)
    oddNumber  += 2
