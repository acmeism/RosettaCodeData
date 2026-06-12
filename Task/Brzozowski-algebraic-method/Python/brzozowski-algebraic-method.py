class RE:
    def __eq__(self, other):
        return isinstance(other, type(self)) and self.__dict__ == other.__dict__

class Empty(RE):
    def __str__(self):
        return "0"

empty = Empty()

class Epsilon(RE):
    def __str__(self):
        return "1"

epsilon = Epsilon()

class Car(RE):
    def __init__(self, c):
        self.c = c

    def __str__(self):
        return self.c

    def __eq__(self, other):
        return isinstance(other, Car) and self.c == other.c

class Union(RE):
    def __init__(self, e, f):
        self.e = e
        self.f = f

    def __str__(self):
        return f"{self.e}+{self.f}"

    def __eq__(self, other):
        return isinstance(other, Union) and self.e == other.e and self.f == other.f

class Concat(RE):
    def __init__(self, e, f):
        self.e = e
        self.f = f

    def __str__(self):
        return f"({self.e})({self.f})"

    def __eq__(self, other):
        return isinstance(other, Concat) and self.e == other.e and self.f == other.f

class Star(RE):
    def __init__(self, e):
        self.e = e

    def __str__(self):
        return f"({self.e})*"

    def __eq__(self, other):
        return isinstance(other, Star) and self.e == other.e

def simple_re(e):
    def simple(e):
        if isinstance(e, Union):
            e_e = simple(e.e)
            e_f = simple(e.f)
            if e_e == e_f:
                return e_e
            elif isinstance(e_e, Union):
                return simple(Union(e_e.e, Union(e_e.f, e_f)))
            elif e_e == empty:
                return e_f
            elif e_f == empty:
                return e_e
            else:
                return Union(e_e, e_f)
        elif isinstance(e, Concat):
            e_e = simple(e.e)
            e_f = simple(e.f)
            if e_e == epsilon:
                return e_f
            elif e_f == epsilon:
                return e_e
            elif e_e == empty or e_f == empty:
                return empty
            elif isinstance(e_e, Concat):
                return simple(Concat(e_e.e, Concat(e_e.f, e_f)))
            else:
                return Concat(e_e, e_f)
        elif isinstance(e, Star):
            e_e = simple(e.e)
            if isinstance(e_e, Empty) or isinstance(e_e, Epsilon):
                return epsilon
            else:
                return Star(e_e)
        else:
            return e
    prev_e = None
    while e != prev_e:
        prev_e = e
        e = simple(e)
    return e

def brzozowski(a, b):
    m = len(a)
    for n in range(m-1, -1, -1):
        a_nn = a[n][n]
        b[n] = Concat(Star(a_nn), b[n])
        for j in range(n):
            a[n][j] = Concat(Star(a_nn), a[n][j])
        for i in range(n):
            b[i] = Union(b[i], Concat(a[i][n], b[n]))
            for j in range(n):
                a[i][j] = Union(a[i][j], Concat(a[i][n], a[n][j]))
        for i in range(n):
            a[i][n] = empty
    return b[0]

a = [
    [empty, Car('a'), Car('b')],
    [Car('b'), empty, Car('a')],
    [Car('a'), Car('b'), empty],
]

b = [epsilon, empty, empty]

re = brzozowski(a, b)
print(str(re))
print()
print(str(simple_re(re)))
