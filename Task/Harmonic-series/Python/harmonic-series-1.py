from  fractions import Fraction

def harmonic_series():
    n, h = Fraction(1), Fraction(1)
    while True:
        yield h
        h += 1 / (n + 1)
        n += 1

if __name__ == '__main__':
    from itertools import islice
    for n, d in (h.as_integer_ratio() for h in islice(harmonic_series(), 20)):
        print(n, '/', d)
