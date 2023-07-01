def isPrime(n):
    for x in 2, 3:
        if not n % x:
            return n == x
    d = 5
    while d * d <= n:
        for x in 2, 4:
            if not n % d:
                return False
            d += x
    return True

i = 42
n = 0
while n < 42:
    if isPrime(i):
        n += 1
        print('n = {:2} {:20,}'.format(n, i))
        i += i - 1
    i += 1
