#Aamrun, 5th October 2021

from math import prod

def superFactorial(n):
    return prod([prod(range(1,i+1)) for i in range(1,n+1)])

def hyperFactorial(n):
    return prod([i**i for i in range(1,n+1)])

def alternatingFactorial(n):
    return sum([(-1)**(n-i)*prod(range(1,i+1)) for i in range(1,n+1)])

def exponentialFactorial(n):
    if n in [0,1]:
        return 1
    else:
        return n**exponentialFactorial(n-1)

def inverseFactorial(n):
    i = 1
    while True:
        if n == prod(range(1,i)):
            return i-1
        elif n < prod(range(1,i)):
            return "undefined"
        i+=1

print("Superfactorials for [0,9] :")
print({"sf(" + str(i) + ") " : superFactorial(i) for i in range(0,10)})

print("\nHyperfactorials for [0,9] :")
print({"H(" + str(i) + ") "  : hyperFactorial(i) for i in range(0,10)})

print("\nAlternating factorials for [0,9] :")
print({"af(" + str(i) + ") " : alternatingFactorial(i) for i in range(0,10)})

print("\nExponential factorials for [0,4] :")
print({str(i) + "$ " : exponentialFactorial(i) for i in range(0,5)})

print("\nDigits in 5$ : " , len(str(exponentialFactorial(5))))

factorialSet = [1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800]

print("\nInverse factorials for " , factorialSet)
print({"rf(" + str(i) + ") ":inverseFactorial(i) for i in factorialSet})

print("\nrf(119) : " + inverseFactorial(119))
