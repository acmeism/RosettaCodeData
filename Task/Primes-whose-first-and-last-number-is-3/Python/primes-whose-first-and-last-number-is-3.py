def prime(n):
    if n == 1:
        return False
    if n == 2:
        p.append(n)
        return True
    for y in p:
        if n % y == 0:
            return False
        if y > int(n ** 0.5):
            p.append(n)
            return True


p = []
x = 1
stopper = 0
lis = []

for i in range(0, 1000000):
    x += 1
    if prime(x) == True:
        str_x = str(x)
        if str_x[0] == "3" and str_x[-1] == "3":
                lis.append(x)
    if int(x) == 4000 and stopper == 0:
        print(f'There are {len(lis)} primes that start and end with 3 less than 4000')
        for i in lis:
            print(i)

print(f'There are {len(lis)} primes that start and end with 3 less than 1000000')
