""" rosettacode.org task Ormiston_pairs """

from sympy import primerange


PRIMES1M = list(primerange(1, 1_000_000))
ASBASE10SORT = [str(sorted(list(str(i)))) for i in PRIMES1M]
ORMISTONS = [(PRIMES1M[i - 1], PRIMES1M[i]) for i in range(1, len(PRIMES1M))
             if ASBASE10SORT[i - 1] == ASBASE10SORT[i]]

print('First 30 Ormiston pairs:')
for (i, o) in enumerate(ORMISTONS):
    if i < 30:
        print(f'({o[0] : 6} {o[1] : 6} )',
              end='\n' if (i + 1) % 5 == 0 else '  ')
    else:
        break

print(len(ORMISTONS), 'is the count of Ormiston pairs up to one million.')
