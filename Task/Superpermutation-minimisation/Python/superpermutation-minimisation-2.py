from array import array
from string import ascii_uppercase, digits
from operator import mul

try:
    import psyco
    psyco.full()
except:
    pass

N_MAX = 12

# fact_sum(n) = 1! + 2! + ... + n!
def fact_sum(n):
    return sum(reduce(mul, xrange(1, m + 1), 1) for m in xrange(1, n + 1))


def r(n, superperm, pos, count):
    if not n:
        return False

    c = superperm[pos - n]
    count[n] -= 1
    if not count[n]:
        count[n] = n
        if not r(n - 1, superperm, pos, count):
            return False

    superperm[pos] = c
    pos += 1
    return True


def super_perm(n, superperm, pos, count, chars = digits + ascii_uppercase):
    assert len(chars) >= N_MAX
    pos = n
    superperm += array("c", " ") * (fact_sum(n) - len(superperm))

    for i in xrange(n + 1):
        count[i] = i
    for i in xrange(1, n + 1):
        superperm[i - 1] = chars[i]

    while r(n, superperm, pos, count):
        pass


def main():
    superperm = array("c", "")
    pos = 0
    count = array("l", [0]) * N_MAX

    for n in xrange(N_MAX):
        super_perm(n, superperm, pos, count)
        print "Super perm(%2d) len = %d" % (n, len(superperm)),
        #print superperm.tostring(),
        print

main()
