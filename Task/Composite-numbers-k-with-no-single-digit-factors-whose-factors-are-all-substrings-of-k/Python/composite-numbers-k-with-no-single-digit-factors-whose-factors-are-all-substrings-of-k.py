from sympy import isprime, factorint

def contains_its_prime_factors_all_over_7(n):
    if n < 10 or isprime(n):
        return False
    strn = str(n)
    pfacs = factorint(n).keys()
    return all(f > 9 and str(f) in strn for f in pfacs)

found = 0
for n in range(1_000_000_000):
    if contains_its_prime_factors_all_over_7(n):
        found += 1
        print(f'{n: 12,}', end = '\n' if found % 10 == 0 else '')
        if found == 20:
            break
