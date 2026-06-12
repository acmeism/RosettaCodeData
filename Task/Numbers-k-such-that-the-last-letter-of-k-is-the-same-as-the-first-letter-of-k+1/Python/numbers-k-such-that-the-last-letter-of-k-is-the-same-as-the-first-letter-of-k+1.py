""" rosettacode.org, wiki task regarding OEIS sequence A363659 """

from collections import Counter
from ascii_graph import Pyasciigraph
from num2words import num2words

sspelledcache = [num2words(n) for n in range(1000)]
firstcache, lastcache = [s[0] for s in sspelledcache], [s[-1] for s in sspelledcache]

def qualifies(n):
    lastchar = lastcache[n % 1000] if n % 1000 > 0 else 'o' if n == 0 else \
       'n' if n % 1_000_000 == 0 else 'd'
    n += 1
    j = 0
    while n > 0:
        n, j = divmod(n, 1000)
    return firstcache[j] == lastchar

def testqualifies():
    """ Test the generation of OEIS sequence A363659 """
    ncount = 0
    lastdigits = Counter()
    print("First 50 qualifying numbers:")
    for num in range(1_000_000_000):
        if qualifies(num):
            ncount += 1
            lastdigits.update([num % 10])
            if ncount < 51:
                print(f'{num:5}', end='\n' if ncount % 10 == 0 else '')
            elif ncount in [10**3, 10**4, 10**5, 10**6]:
                print(f'\nThe {num2words(ncount)}th number is {num:,}.')
                print('Breakdown by last digit of the qualifiers up to this:')
                graph = Pyasciigraph()
                for line in graph.graph('Frequencies', sorted(lastdigits.items())):
                    print(line)
                print()

            if ncount == 1_000_000:
                break


if __name__ == '__main__':

    testqualifies()
