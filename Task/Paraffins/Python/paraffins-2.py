from itertools import count, chain, tee, islice, cycle
from fractions import Fraction
from sys import setrecursionlimit
setrecursionlimit(5000)

def frac(a,b): return a//b if a%b == 0 else Fraction(a,b)

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
            s.gen, self.gen = tee(s.gen, 2)

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
            return Poly(frac(x, b) for x in a)

        a, b = Poly(a), Poly(b)
        def gen():
            r, bb = a,next(b)
            while True:
                aa = next(r)
                q = frac(aa, bb)
                yield(q)
                r -= q*b

        return Poly(gen())

    def repl(self, n):
        def gen():
            for x in self:
                yield(x)
                for i in range(n-1): yield(0)
        return Poly(gen())

    def __pow__(self, n):
        return Poly(self) if n == 1 else self * self**(n-1)

def S2(a,b): return (a*a + b)/2
def S4(a,b,c,d): return a**4/24 + a**2*b/4 + a*c/3 + b**2/8 + d/4

x1 = Poly()
x2 = x1.repl(2)
x3 = x1.repl(3)
x4 = x1.repl(4)
x1 << chain([1], (x1**3 + 3*x1*x2 + 2*x3)/6)

a598 = x1
a678 = Poly(chain([0], S4(x1, x2, x3, x4)))
a599 = S2(x1 - 1, x2 - 1)
a602 = a678 - a599 + x2

for n,x in zip(count(0), islice(a602, 500)): print(n,x)
