from sympy import isprime, divisors

def is_super_Poulet(n):
    return not isprime(n) and 2**(n - 1) % n == 1 and all((2**d - 2) % d == 0 for d in divisors(n))

spoulets = [n for n in range(1, 1_100_000) if is_super_Poulet(n)]

print('The first 20 super-Poulet numbers are:', spoulets[:20])

idx1m, val1m = next((i, v) for i, v in enumerate(spoulets) if v > 1_000_000)
print(f'The first super-Poulet number over 1 million is the {idx1m}th one, which is {val1m}')

