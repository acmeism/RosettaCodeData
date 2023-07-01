from sympy import divisors

from sympy.combinatorics.subsets import Subset

def isZumkeller(n):
    d = divisors(n)
    s = sum(d)
    if not s % 2 and max(d) <= s/2:
        for x in range(1, 2**len(d)):
            if sum(Subset.unrank_binary(x, d).subset) == s/2:
                return True

    return False



def printZumkellers(N, oddonly=False):
    nprinted = 0
    for n in range(1, 10**5):
        if (oddonly == False or n % 2) and isZumkeller(n):
            print(f'{n:>8}', end='')
            nprinted += 1
            if nprinted % 10 == 0:
                print()
            if nprinted >= N:
                return


print("220 Zumkeller numbers:")
printZumkellers(220)
print("\n\n40 odd Zumkeller numbers:")
printZumkellers(40, True)
