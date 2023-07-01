''' \
For a discussion on pipe() and head() see
  http://paddy3118.blogspot.com/2009/05/pipe-fitting-with-python-generators.html
'''

from itertools import islice
from fractions import Fraction
from functools import reduce
try:
    from itertools import izip as zip # for 2.6
except:
    pass

def head(n):
    ''' return a generator that passes through at most n items
    '''
    return lambda seq: islice(seq, n)

def pipe(gen, *cmds):
    ''' pipe(a,b,c,d, ...) -> yield from ...d(c(b(a)))
    '''
    return reduce(lambda gen, cmd: cmd(gen), cmds, gen)

def sinepower():
    n = 0
    fac = 1
    sign = +1
    zero = 0
    yield zero
    while True:
        n +=1
        fac *= n
        yield Fraction(1, fac*sign)
        sign = -sign
        n +=1
        fac *= n
        yield zero
def cosinepower():
    n = 0
    fac = 1
    sign = +1
    yield Fraction(1,fac)
    zero = 0
    while True:
        n +=1
        fac *= n
        yield zero
        sign = -sign
        n +=1
        fac *= n
        yield Fraction(1, fac*sign)
def pluspower(*powergenerators):
    for elements in zip(*powergenerators):
        yield sum(elements)
def minuspower(*powergenerators):
    for elements in zip(*powergenerators):
        yield elements[0] - sum(elements[1:])
def mulpower(fgen,ggen):
    'From: http://en.wikipedia.org/wiki/Power_series#Multiplication_and_division'
    a,b = [],[]
    for f,g in zip(fgen, ggen):
        a.append(f)
        b.append(g)
        yield sum(f*g for f,g in zip(a, reversed(b)))
def constpower(n):
    yield n
    while True:
        yield 0
def diffpower(gen):
    'differentiatiate power series'
    next(gen)
    for n, an in enumerate(gen, start=1):
        yield an*n
def intgpower(k=0):
    'integrate power series with constant k'
    def _intgpower(gen):
        yield k
        for n, an in enumerate(gen, start=1):
            yield an * Fraction(1,n)
    return _intgpower


print("cosine")
c = list(pipe(cosinepower(), head(10)))
print(c)
print("sine")
s = list(pipe(sinepower(), head(10)))
print(s)
# integrate cosine
integc = list(pipe(cosinepower(),intgpower(0), head(10)))
# 1 - (integrate sine)
integs1 = list(minuspower(pipe(constpower(1), head(10)),
                          pipe(sinepower(),intgpower(0), head(10))))

assert s == integc, "The integral of cos should be sin"
assert c == integs1, "1 minus the integral of sin should be cos"
