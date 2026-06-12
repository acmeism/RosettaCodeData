from sympy import isprime

def ispentapowerprime(n):
    return all(isprime(i) for i in [n + 2, n + n + 1, n**2 + n + 1, n**3 + n + 1, n**4 + n + 1])

ppprimes = [i for i in range(10_400_000) if ispentapowerprime(i)]

for i in range(50):
    print(f'{ppprimes[i]: 11,}', end='\n' if (i + 1) % 10 == 0 else '')

for n in range(1_000_000, 10_000_001, 1_000_000):
    proot = next(filter(lambda x: x > n, ppprimes))
    print(f'The first penta-power prime seed over {n:,} is {proot:,}')
