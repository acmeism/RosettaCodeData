import copy, random

def bitcount(n):
    return bin(n).count("1")

def reoderingSign(i, j):
    k = i >> 1
    sum = 0
    while k != 0:
        sum += bitcount(k & j)
        k = k >> 1
    return 1.0 if ((sum & 1) == 0) else -1.0

class Vector:
    def __init__(self, da):
        self.dims = da

    def dot(self, other):
        return (self * other + other * self) * 0.5

    def __getitem__(self, i):
        return self.dims[i]

    def __setitem__(self, i, v):
        self.dims[i] = v

    def __neg__(self):
        return self * -1.0

    def __add__(self, other):
        result = copy.copy(other.dims)
        for i in xrange(0, len(self.dims)):
            result[i] += self.dims[i]
        return Vector(result)

    def __mul__(self, other):
        if isinstance(other, Vector):
            result = [0.0] * 32
            for i in xrange(0, len(self.dims)):
                if self.dims[i] != 0.0:
                    for j in xrange(0, len(self.dims)):
                        if other.dims[j] != 0.0:
                            s = reoderingSign(i, j) * self.dims[i] * other.dims[j]
                            k = i ^ j
                            result[k] += s
            return Vector(result)
        else:
            result = copy.copy(self.dims)
            for i in xrange(0, len(self.dims)):
                self.dims[i] *= other
            return Vector(result)

    def __str__(self):
        return str(self.dims)

def e(n):
    assert n <= 4, "n must be less than 5"
    result = Vector([0.0] * 32)
    result[1 << n] = 1.0
    return result

def randomVector():
    result = Vector([0.0] * 32)
    for i in xrange(0, 5):
        result += Vector([random.uniform(0, 1)]) * e(i)
    return result

def randomMultiVector():
    result = Vector([0.0] * 32)
    for i in xrange(0, 32):
        result[i] = random.uniform(0, 1)
    return result

def main():
    for i in xrange(0, 5):
        for j in xrange(0, 5):
            if i < j:
                if e(i).dot(e(j))[0] != 0.0:
                    print "Unexpected non-null scalar product"
                    return
                elif i == j:
                    if e(i).dot(e(j))[0] == 0.0:
                        print "Unexpected non-null scalar product"

    a = randomMultiVector()
    b = randomMultiVector()
    c = randomMultiVector()
    x = randomVector()

    # (ab)c == a(bc)
    print (a * b) * c
    print a * (b * c)
    print

    # a(b+c) == ab + ac
    print a * (b + c)
    print a * b + a * c
    print

    # (a+b)c == ac + bc
    print (a + b) * c
    print a * c + b * c
    print

    # x^2 is real
    print x * x

main()
