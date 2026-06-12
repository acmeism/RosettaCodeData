import math

limit = 1000000
Primes = []
oldPrime = 0
newPrime = 0
x = 0

def sieve(n):
    is_prime = [True] * (n + 1)
    is_prime[0] = is_prime[1] = False

    for i in range(2, int(n ** 0.5) + 1):
        if is_prime[i]:
            for j in range(i*i, n + 1, i):
                is_prime[j] = False

    return [i for i in range(n+1) if is_prime[i]]

def issquare(x):
	n = math.isqrt(x)
	return n * n == x

Primes = sieve(limit)

for n in range(2, len(Primes)):
    pr1 = Primes[n]
    pr2 = Primes[n-1]
    diff = pr1 - pr2
    flag = issquare(diff)
    if (flag == 1 and diff > 36):
       print(str(pr1) + " " + str(pr2) + " diff = " + str(diff))
