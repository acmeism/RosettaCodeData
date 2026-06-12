''' rosettacode.org/wiki/Even_numbers_which_cannot_be_expressed_as_the_sum_of_two_twin_primes '''

from sympy import sieve


def nonpairsums(include1=False, limit=20_000):
    """ Even numbers which cannot be expressed as the sum of two twin primes """
    tpri = [i in sieve and (i - 2 in sieve or i + 2 in sieve)
            for i in range(limit+2)]
    if include1:
        tpri[1] = True
    twinsums = [False] * (limit * 2)
    for i in range(limit):
        for j in range(limit-i+1):
            if tpri[i] and tpri[j]:
                twinsums[i + j] = True

    return [i for i in range(2, limit+1, 2) if not twinsums[i]]


print('Non twin prime sums:')
for k, p in enumerate(nonpairsums()):
    print(f'{p:6}', end='\n' if (k + 1) % 10 == 0 else '')

print('\n\nNon twin prime sums (including 1):')
for k, p in enumerate(nonpairsums(include1=True)):
    print(f'{p:6}', end='\n' if (k + 1) % 10 == 0 else '')
