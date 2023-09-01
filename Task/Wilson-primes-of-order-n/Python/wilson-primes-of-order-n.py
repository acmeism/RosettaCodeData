# wilson_prime.py by xing216
def sieve(n):
    multiples = []
    for i in range(2, n+1):
        if i not in multiples:
            yield i
            for j in range(i*i, n+1, i):
                multiples.append(j)
def intListToString(list):
    return " ".join([str(i) for i in list])
limit = 11000
primes = list(sieve(limit))
facs = [1]
for i in range(1,limit):
    facs.append(facs[-1]*i)
sign = 1
print(" n: Wilson primes")
print("—————————————————")

for n in range(1,12):
    sign = -sign
    wilson = []
    for p in primes:
        if p < n: continue
        f = facs[n-1] * facs[p-n] - sign
        if f % p**2 == 0: wilson.append(p)
    print(f"{n:2d}: {intListToString(wilson)}")
