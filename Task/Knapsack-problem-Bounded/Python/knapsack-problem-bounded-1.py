from itertools import groupby
from collections import namedtuple

def anyvalidcomb(items, maxwt, val=0, wt=0):
    ' All combinations below the maxwt '
    if not items:
        yield [], val, wt
    else:
        this, *items = items            # car, cdr
        for n in range(this.number + 1):
            w = wt  + n * this.weight
            if w > maxwt:
                break
            v = val + n * this.value
            this_comb = [this] * n
            for comb, value, weight in anyvalidcomb(items, maxwt, v, w):
                yield this_comb + comb, value, weight

maxwt = 400
COMB, VAL, WT = range(3)
Item  = namedtuple('Items', 'name weight value number')
items = [ Item(*x) for x in
          (
            ("map", 9, 150, 1),
            ("compass", 13, 35, 1),
            ("water", 153, 200, 3),
            ("sandwich", 50, 60, 2),
            ("glucose", 15, 60, 2),
            ("tin", 68, 45, 3),
            ("banana", 27, 60, 3),
            ("apple", 39, 40, 3),
            ("cheese", 23, 30, 1),
            ("beer", 52, 10, 3),
            ("suntan cream", 11, 70, 1),
            ("camera", 32, 30, 1),
            ("t-shirt", 24, 15, 2),
            ("trousers", 48, 10, 2),
            ("umbrella", 73, 40, 1),
            ("waterproof trousers", 42, 70, 1),
            ("waterproof overclothes", 43, 75, 1),
            ("note-case", 22, 80, 1),
            ("sunglasses", 7, 20, 1),
            ("towel", 18, 12, 2),
            ("socks", 4, 50, 1),
            ("book", 30, 10, 2),
           ) ]

bagged = max( anyvalidcomb(items, maxwt), key=lambda c: (c[VAL], -c[WT])) # max val or min wt if values equal
print("Bagged the following %i items" % len(bagged[COMB]))
print('\n\t'.join('%i off: %s' % (len(list(grp)), item.name) for item, grp in groupby(sorted(bagged[COMB]))))
print("for a total value of %i and a total weight of %i" % bagged[1:])
