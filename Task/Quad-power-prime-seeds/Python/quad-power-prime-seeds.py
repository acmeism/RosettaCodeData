""" quad-power prime root numbers """

from sympy import isprime


def isquadpowerprime(cand):
    """ return if is a quad power prime root number """
    return all(isprime(i) for i in
               [cand + cand + 1, cand**2 + cand + 1, cand**3 + cand + 1, cand**4 + cand + 1])


qpprimes = [k for k in range(10_100_000) if isquadpowerprime(k)]

for i in range(50):
    print(f'{qpprimes[i]: 9,}', end='\n' if (i + 1) % 10 == 0 else '')


for j in range(1_000_000, 10_000_001, 1_000_000):
    for p in qpprimes:
        if p > j:
            print(f'The first quad-power prime seed over {j:,} is {p:,}')
            break
