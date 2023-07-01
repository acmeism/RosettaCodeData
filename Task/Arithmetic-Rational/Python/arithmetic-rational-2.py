def lcm(a, b):
    return a // gcd(a,b) * b

def gcd(u, v):
    return gcd(v, u%v) if v else abs(u)

class Fraction:
    def __init__(self, numerator, denominator):
        common = gcd(numerator, denominator)
        self.numerator = numerator//common
        self.denominator = denominator//common
    def __add__(self, frac):
        common = lcm(self.denominator, frac.denominator)
        n = common // self.denominator * self.numerator + common // frac.denominator * frac.numerator
        return Fraction(n, common)
    def __sub__(self, frac):
        return self.__add__(-frac)
    def __neg__(self):
        return Fraction(-self.numerator, self.denominator)
    def __abs__(self):
        return Fraction(abs(self.numerator), abs(self.denominator))
    def __mul__(self, frac):
        return Fraction(self.numerator * frac.numerator, self.denominator * frac.denominator)
    def __div__(self, frac):
        return self.__mul__(frac.reciprocal())
    def reciprocal(self):
        return Fraction(self.denominator, self.numerator)
    def __cmp__(self, n):
        return int(float(self) - float(n))
    def __float__(self):
        return float(self.numerator / self.denominator)
    def __int__(self):
        return (self.numerator // self.denominator)
