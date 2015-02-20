from __future__ import print_function

from scipy.misc import factorial as fact
from scipy.misc import comb

def perm(N, k, exact=0):
    return comb(N, k, exact) * fact(k, exact)

exact=True
print('Sample Perms 1..12')
for N in range(1, 13):
    k = max(N-2, 1)
    print('%iP%i =' % (N, k), perm(N, k, exact), end=', ' if N % 5 else '\n')

print('\n\nSample Combs 10..60')
for N in range(10, 61, 10):
    k = N-2
    print('%iC%i =' % (N, k), comb(N, k, exact), end=', ' if N % 50 else '\n')

exact=False
print('\n\nSample Perms 5..1500 Using FP approximations')
for N in [5, 15, 150, 1500, 15000]:
    k = N-2
    print('%iP%i =' % (N, k), perm(N, k, exact))

print('\nSample Combs 100..1000 Using FP approximations')
for N in range(100, 1001, 100):
    k = N-2
    print('%iC%i =' % (N, k), comb(N, k, exact))
