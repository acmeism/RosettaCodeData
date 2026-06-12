class Head():
    def __init__(self, lo, hi=None, shift=0):
        if hi is None: hi = lo

        d = hi - lo
        ds, ls, hs = str(d), str(lo), str(hi)

        if d and len(ls) > len(ds):
            assert(len(ls) - len(ds) + 1 > 21)
            lo = int(str(lo)[:len(ls) - len(ds) + 1])
            hi = int(str(hi)[:len(hs) - len(ds) + 1]) + 1
            shift += len(ds) - 1
        elif len(ls) > 100:
            lo = int(str(ls)[:100])
            hi = lo + 1
            shift = len(ls) - 100

        self.lo, self.hi, self.shift = lo, hi, shift

    def __mul__(self, other):
        lo = self.lo*other.lo
        hi = self.hi*other.hi
        shift = self.shift + other.shift

        return Head(lo, hi, shift)

    def __add__(self, other):
        if self.shift < other.shift:
            return other + self

        sh = self.shift - other.shift
        if sh >= len(str(other.hi)):
            return Head(self.lo, self.hi, self.shift)

        ls = str(other.lo)
        hs = str(other.hi)

        lo = self.lo + int(ls[:len(ls)-sh])
        hi = self.hi + int(hs[:len(hs)-sh])

        return Head(lo, hi, self.shift)

    def __repr__(self):
        return str(self.hi)[:20]

class Tail():
    def __init__(self, v):
        self.v = int(f'{v:020d}'[-20:])

    def __add__(self, other):
        return Tail(self.v + other.v)

    def __mul__(self, other):
        return Tail(self.v*other.v)

    def __repr__(self):
        return f'{self.v:020d}'[-20:]

def mul(a, b):
    return a[0]*b[0] + a[1]*b[1], a[0]*b[1] + a[1]*b[2], a[1]*b[1] + a[2]*b[2]

def fibo(n, cls):
    n -= 1
    zero, one = cls(0), cls(1)
    m = (one, one, zero)
    e = (one, zero, one)

    while n:
        if n&1: e = mul(m, e)
        m = mul(m, m)
        n >>= 1

    return f'{e[0]}'

for i in range(2, 10):
    n = 10**i
    print(f'10^{i} :', fibo(n, Head), '...', fibo(n, Tail))

for i in range(3, 8):
    n = 2**i
    s = f'2^{n}'
    print(f'{s:5s}:', fibo(2**n, Head), '...', fibo(2**n, Tail))
