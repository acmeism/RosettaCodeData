from random import randrange
from typing import List

Perm = List[int]

_fact = [1]     # factorials cache


def print_perm(T: Perm) -> None:
    print(T)

def tj_unrank(n: int, r: int) -> Perm:
    "Returns the r-ranked Trotter-Johnson permutation of integers 0..n-1"
    global _fact

    for i in range(len(_fact), n+2):    # Extend factorial cache if necessary.
        _fact.append(_fact[i - 1] * i)

    pi: Perm = [0] * (n+2)
    pi[1] = 1
    r2 = 0
    for j in range(2, n+1):
        r1 = (r * _fact[j]) // _fact[n]
        k = r1 - j*r2
        if ((r2 % 2) == 0):
            for i in range(j-1, j - k - 1, -1):
                pi[i+1] = pi[i]
            pi[j-k] = j
        else:
            for i in range(j - 1, k, -1):
                pi[i+1] = pi[i]
            pi[k + 1] = j
        r2 = r1

    return [i - 1 for i in pi[1:-1]]

def tj_rank(p: Perm) -> int:
    "Returns the ranking of the Trotter-Johnson permutation p, of integers 0..n-1"
    n = len(p)
    assert set(p) == set(range(n)), f"Perm {p} not a perm of 0..{n-1}."

    pi = [0] + [i+1 for i in p] + [0]
    r = 0
    for j in range(2, n + 1):
        i = k = 1
        while pi[i] != j:
            if (pi[i] < j):
                k += 1
            i += 1
        if ((r % 2) == 0 ):
            r = j*r+j-k
        else:
            r = j*r+k-1

    return r

def tj_parity(p: Perm) -> int:
    "Returns the 0/1 parity of the Trotter-Johnson permutation p, of integers 0..n-1"
    n = len(p)
    assert set(p) == set(range(n)), f"Perm {p} not a perm of 0..{n-1}."

    pi = [0] + [i+1 for i in p] + [0]
    a, c = [0] * (n + 1), 0
    for j in range(1, n+1):
        if a[j] == 0:
            c += 1
            a[j] = 1
            i = j
            while ( pi[i] != j ):
                i = pi[i]
                a[i] = 1

    return (n-c) % 2

def get_random_ranks(permsize, samplesize, fact):
    perms = fact[permsize]
    ranks = set()
    while len(ranks) < samplesize:
        ranks |= set( randrange(perms)
                      for r in range(samplesize - len(ranks)) )
    return ranks

if __name__ == '__main__':
    n = 3

    print(f"Testing rank/unrank n={n}.\n");

    for i in range(len(_fact), n+2):    # Extend factorial cache if necessary.
        _fact.append(_fact[i - 1] * i)
    for r in range(_fact[n]):
        p = tj_unrank(n, r)
        rank = tj_rank(p)
        parity = tj_parity(p)
        print(f"  Rank: {r:4} to perm: {p}, parity: {parity} back to rank: {rank}")

    for samplesize, n2 in [(4, 12), (3, 144)]:
        print('\n  %i random individual samples of %i items:' % (samplesize, n2))
        for i in range(len(_fact), max([n, n2])+2):    # Extend factorial cache if necessary.
            _fact.append(_fact[i - 1] * i)
        for r in get_random_ranks(n2, samplesize, _fact):
            p = tj_unrank(n2, r)
            rank = tj_rank(p)
            parity = tj_parity(p)
            print(f"  Rank: {r:10} to perm: {p}, parity: {parity} to rank: {rank:10}")
