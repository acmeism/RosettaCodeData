''' Rosetta code rosettacode.org/wiki/Product_of_min_and_max_prime_factors '''


from sympy import factorint

NUM_WANTED = 100

for num in range(1, NUM_WANTED + 1):
    fac = factorint(num, multiple=True)
    product = fac[0] * fac[-1] if len(fac) > 0 else 1
    print(f'{product:5}', end='\n' if num % 10 == 0 else '')
