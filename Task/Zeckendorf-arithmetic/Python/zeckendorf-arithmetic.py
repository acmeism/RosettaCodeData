import copy

class Zeckendorf:
    def __init__(self, x='0'):
        q = 1
        i = len(x) - 1
        self.dLen = int(i / 2)
        self.dVal = 0
        while i >= 0:
            self.dVal = self.dVal + (ord(x[i]) - ord('0')) * q
            q = q * 2
            i = i -1

    def a(self, n):
        i = n
        while True:
            if self.dLen < i:
                self.dLen = i
            j = (self.dVal >> (i * 2)) & 3
            if j == 0 or j == 1:
                return
            if j == 2:
                if (self.dVal >> ((i + 1) * 2) & 1) != 1:
                    return
                self.dVal = self.dVal + (1 << (i * 2 + 1))
                return
            if j == 3:
                temp = 3 << (i * 2)
                temp = temp ^ -1
                self.dVal = self.dVal & temp
                self.b((i + 1) * 2)
            i = i + 1

    def b(self, pos):
        if pos == 0:
            self.inc()
            return
        if (self.dVal >> pos) & 1 == 0:
            self.dVal = self.dVal + (1 << pos)
            self.a(int(pos / 2))
            if pos > 1:
                self.a(int(pos / 2) - 1)
        else:
            temp = 1 << pos
            temp = temp ^ -1
            self.dVal = self.dVal & temp
            self.b(pos + 1)
            self.b(pos - (2 if pos > 1 else 1))

    def c(self, pos):
        if (self.dVal >> pos) & 1 == 1:
            temp = 1 << pos
            temp = temp ^ -1
            self.dVal = self.dVal & temp
            return
        self.c(pos + 1)
        if pos > 0:
            self.b(pos - 1)
        else:
            self.inc()

    def inc(self):
        self.dVal = self.dVal + 1
        self.a(0)

    def __add__(self, rhs):
        copy = self
        rhs_dVal = rhs.dVal
        limit = (rhs.dLen + 1) * 2
        for gn in range(0, limit):
            if ((rhs_dVal >> gn) & 1) == 1:
                copy.b(gn)
        return copy

    def __sub__(self, rhs):
        copy = self
        rhs_dVal = rhs.dVal
        limit = (rhs.dLen + 1) * 2
        for gn in range(0, limit):
            if (rhs_dVal >> gn) & 1 == 1:
                copy.c(gn)
        while (((copy.dVal >> ((copy.dLen * 2) & 31)) & 3) == 0) or (copy.dLen == 0):
            copy.dLen = copy.dLen - 1
        return copy

    def __mul__(self, rhs):
        na = copy.deepcopy(rhs)
        nb = copy.deepcopy(rhs)
        nr = Zeckendorf()
        dVal = self.dVal
        for i in range(0, (self.dLen + 1) * 2):
            if ((dVal >> i) & 1) > 0:
                nr = nr + nb
            nt = copy.deepcopy(nb)
            nb = nb + na
            na = copy.deepcopy(nt)
        return nr

    def __str__(self):
        dig = ["00", "01", "10"]
        dig1 = ["", "1", "10"]

        if self.dVal == 0:
            return '0'
        idx = (self.dVal >> ((self.dLen * 2) & 31)) & 3
        sb = dig1[idx]
        i = self.dLen - 1
        while i >= 0:
            idx = (self.dVal >> (i * 2)) & 3
            sb = sb + dig[idx]
            i = i - 1
        return sb

# main
print "Addition:"
g = Zeckendorf("10")
g = g + Zeckendorf("10")
print g
g = g + Zeckendorf("10")
print g
g = g + Zeckendorf("1001")
print g
g = g + Zeckendorf("1000")
print g
g = g + Zeckendorf("10101")
print g
print

print "Subtraction:"
g = Zeckendorf("1000")
g = g - Zeckendorf("101")
print g
g = Zeckendorf("10101010")
g = g - Zeckendorf("1010101")
print g
print

print "Multiplication:"
g = Zeckendorf("1001")
g = g * Zeckendorf("101")
print g
g = Zeckendorf("101010")
g = g + Zeckendorf("101")
print g
