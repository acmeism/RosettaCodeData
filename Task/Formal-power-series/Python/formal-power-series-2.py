from itertools import islice, tee
from fractions import Fraction
try:
    from itertools import izip as zip # for 2.6
except:
    pass

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
def intgpower(gen):
    'integrate power series with bounds from 0 to x'
    yield 0
    for n, an in enumerate(gen, start=1):
        yield an * Fraction(1,n)


def sine_cosine_series():
    def deferred_sin():
        for i in sinx_temp:
            yield i
    def deferred_cos():
        for i in cosx_temp:
            yield i

    sinx_result, sinx_copy1 = tee(deferred_sin(), 2)
    cosx_result, cosx_copy1 = tee(deferred_cos(), 2)

    sinx_temp = intgpower(cosx_copy1)
    cosx_temp = minuspower(constpower(1), intgpower(sinx_copy1))

    return sinx_result, cosx_result

sinx, cosx = sine_cosine_series()

print("cosine")
print(list(islice(sinx, 10)))
print("sine")
print(list(islice(cosx, 10)))
