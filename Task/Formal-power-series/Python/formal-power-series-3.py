from itertools import count, chain, tee, islice, cycle
from fractions import Fraction

# infinite polynomial class
class Poly:
    def __init__(self, gen = None):
        self.gen, self.source = (None, gen) if type(gen) is Poly \
            else (gen, None)

    def __iter__(self):
        # We're essentially tee'ing it everytime the iterator
        # is, well, iterated.  This may be excessive.
        return Poly(self)

    def getsource(self):
        if self.gen == None:
            s = self.source
            s.getsource()
            (a,b) = tee(s.gen, 2)
            s.gen = a
            self.gen = b

    def next(self):
        self.getsource()
        return next(self.gen)

    __next__ = next

    # Overload "<<" as stream input operator. Hey, C++ does it.
    def __lshift__(self, a): self.gen = a

    # The other operators are pretty much what one would expect
    def __neg__(self): return Poly(-x for x in self)

    def __sub__(a, b): return a + (-b)

    def __rsub__(a, n):
        a = Poly(a)
        def gen():
            yield(n - next(a))
            for x in a: yield(-x)
        return Poly(gen())

    def __add__(a, b):
        if type(b) is Poly:
            return Poly(x + y for (x,y) in zip(a,b))

        a = Poly(a)
        def gen():
            yield(next(a) + b)
            for x in a: yield(x)
        return Poly(gen())

    def __radd__(a,b):
        return a + b

    def __mul__(a,b):
        if not type(b) is Poly:
            return Poly(x*b for x in a)

        def gen():
            s = Poly(cycle([0]))
            for y in b:
                s += y*a
                yield(next(s))

        return Poly(gen())

    def __rmul__(a,b): return a*b

    def __truediv__(a,b):
        if not type(b) is Poly:
            return Poly(Fraction(x, b) for x in a)

        a, b = Poly(a), Poly(b)
        def gen():
            r, bb = a,next(b)
            while True:
                aa = next(r)
                q = Fraction(aa, bb)
                yield(q)
                r -= q*b

        return Poly(gen())

# these two would probably be better as class methods
def inte(a):
    def gen():
        yield(0)
        for (x,n) in zip(a, count(1)):
            yield(Fraction(x,n))
    return Poly(gen())

def diff(a):
    def gen():
        for (x, n) in zip(a, count(0)):
            if n: yield(x*n)
    return Poly(gen())


# all that for the syntactic sugar
sinx, cosx, tanx, expx = Poly(), Poly(), Poly(), Poly()

sinx << inte(cosx)
cosx << 1 - inte(sinx)
tanx << sinx / cosx        # "=" would also work here
expx << 1 + inte(expx)

for n,x in zip(("sin", "cos", "tan", "exp"), (sinx, cosx, tanx, expx)):
    print(n, ', '.join(map(str, list(islice(x, 10)))))
