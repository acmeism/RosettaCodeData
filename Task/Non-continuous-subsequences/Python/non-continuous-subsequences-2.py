from sys import argv
import psyco

def C(n, k):
    result = 1
    for d in xrange(1, k+1):
        result *= n
        n -= 1
        result /= d
    return result

# http://oeis.org/A002662
nsubs = lambda n: sum(C(n, k) for k in xrange(3, n+1))

def ncsub(seq):
    n = len(seq)
    result = [None] * nsubs(n)
    pos = 0

    for i in xrange(1, 2 ** n):
        S  = []
        nc = False
        for j in xrange(n + 1):
            k = i >> j
            if k == 0:
                if nc:
                    result[pos] = S
                    pos += 1
                break
            elif k % 2:
                S.append(seq[j])
            elif S:
                nc = True
    return result

from sys import argv
import psyco
psyco.full()
n = 10 if len(argv) < 2 else int(argv[1])
print len( ncsub(range(1, n)) )
