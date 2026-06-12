def factorial(n):
    if n-1 < len(factorials):
        return factorials[n - 1]
    total = 1
    for i in range(1, n + 1):
        total *= i
    factorials.append(total)
    return total

def prime(n):
    for y in p:
        if n % y == 0:
            return False
        if y > int(n ** 0.5):
            return True

def erdos(pr):
    sub = 1
    while factorial(sub) <= pr:
        if pr - factorial(sub) in p:
            return False
        else:
            sub += 1
    return True

factorials = []
stopper = 0
x = -1
counter = 0
list = []
p = [2]
coeff = -1


while counter < 7875:
    x += 1
    if x < len(p):
        if erdos(p[x]) == True:
            if p[x] < 2500:
                print(p[x])
            if p[x] > 2500 and stopper == 0:
                print(f'There are {counter} Erdos primes less than 2500')
                stopper = 1
            counter += 1
    else:
        coeff += 1
        for i in range(coeff * 10000 + 2, (coeff + 1) * 10000 + 2):
            if prime(i) == True:
                p.append(i)
        x -= 1

print(f'The {counter}th Erdos prime is {p[x]}')
