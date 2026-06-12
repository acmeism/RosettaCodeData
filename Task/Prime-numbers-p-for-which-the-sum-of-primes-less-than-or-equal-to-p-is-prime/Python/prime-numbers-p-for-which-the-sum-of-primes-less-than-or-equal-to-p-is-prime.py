def prime(n):
    for i in range(2, int(n ** 0.5) + 1):
        if n % i == 0:
            return False
    return True

p = []
x = 1
lis = []


for i in range(0, 1000):
    x += 1
    if prime(x) == True:
        p.append(x)
        str_x = str(x)
        if prime(sum(p)) == True:
                lis.append(x)
    if int(x) == 1000:
        print(f'Found {len(lis)} primes less than 1000')
        for i in lis:
            print(i)
