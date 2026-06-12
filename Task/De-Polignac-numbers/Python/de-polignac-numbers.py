''' Rosetta code rosettacode.org/wiki/De_Polignac_numbers '''

from sympy import isprime
from math import log
from numpy import ndarray

max_value = 1_000_000

all_primes = [i for i in range(max_value + 1) if isprime(i)]
powers_of_2 = [2**i for i in range(int(log(max_value, 2)))]

allvalues = ndarray(max_value, dtype=bool)
allvalues[:] = True

for i in all_primes:
    for j in powers_of_2:
        if i + j < max_value:
            allvalues[i + j] = False

dePolignac = [n for n in range(1, max_value) if n & 1 == 1 and allvalues[n]]

print('First fifty de Polignac numbers:')
for i, n in enumerate(dePolignac[:50]):
    print(f'{n:5}', end='\n' if (i + 1) % 10 == 0 else '')

print(f'\nOne thousandth: {dePolignac[999]:,}')
print(f'\nTen thousandth: {dePolignac[9999]:,}')
