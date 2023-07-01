from numpy import Inf

class MaxTropical:
    """
    Class for max tropical algebra.
    x + y is max(x, y) and X * y is x + y
    """
    def __init__(self, x=0):
        self.x = x

    def __str__(self):
        return str(self.x)

    def __add__(self, other):
        return MaxTropical(max(self.x, other.x))

    def __mul__(self, other):
        return MaxTropical(self.x + other.x)

    def __pow__(self, other):
        assert other.x // 1 == other.x and other.x > 0, "Invalid Operation"
        return MaxTropical(self.x * other.x)

    def __eq__(self, other):
        return self.x == other.x


if __name__ == "__main__":
    a = MaxTropical(-2)
    b = MaxTropical(-1)
    c = MaxTropical(-0.5)
    d = MaxTropical(-0.001)
    e = MaxTropical(0)
    f = MaxTropical(0.5)
    g = MaxTropical(1)
    h = MaxTropical(1.5)
    i = MaxTropical(2)
    j = MaxTropical(5)
    k = MaxTropical(7)
    l = MaxTropical(8)
    m = MaxTropical(-Inf)

    print("2 * -2 == ", i * a)
    print("-0.001 + -Inf == ", d + m)
    print("0 * -Inf == ", e * m)
    print("1.5 + -1 == ", h + b)
    print("-0.5 * 0 == ", c * e)
    print("5**7 == ", j**k)
    print("5 * (8 + 7)) == ", j * (l + k))
    print("5 * 8 + 5 * 7 == ", j * l + j * k)
    print("5 * (8 + 7) == 5 * 8 + 5 * 7", j * (l + k) == j * l + j * k)
