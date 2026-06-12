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
        if str(x).count("1") + str(x).count("3") + str(x).count("5") + str(x).count("7") + str(x).count("9") == 1:
                lis.append(x)
    if int(x) == 1000 and stopper == 0:
        print(f'There are {len(lis)} primes with one odd digit less than 1000')
        for i in lis:
            print(i)

print(f'There are {len(lis)} primes with one odd digit less than 1000000')
