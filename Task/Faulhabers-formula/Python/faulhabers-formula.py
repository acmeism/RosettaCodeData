from fractions import Fraction

def nextu(a):
    n = len(a)
    a.append(1)
    for i in range(n - 1, 0, -1):
        a[i] = i * a[i] + a[i - 1]
    return a

def nextv(a):
    n = len(a) - 1
    b = [(1 - n) * x for x in a]
    b.append(1)
    for i in range(n):
        b[i + 1] += a[i]
    return b

def sumpol(n):
    u = [0, 1]
    v = [[1], [1, 1]]
    yield [Fraction(0), Fraction(1)]
    for i in range(1, n):
        v.append(nextv(v[-1]))
        t = [0] * (i + 2)
        p = 1
        for j, r in enumerate(u):
            r = Fraction(r, j + 1)
            for k, s in enumerate(v[j + 1]):
                t[k] += r * s
        yield t
        u = nextu(u)

def polstr(a):
    s = ""
    q = False
    n = len(a) - 1
    for i, x in enumerate(reversed(a)):
        i = n - i
        if i < 2:
            m = "n" if i == 1 else ""
        else:
            m = "n^%d" % i
        c = str(abs(x))
        if i > 0:
            if c == "1":
                c = ""
            else:
                m = " " + m
        if x != 0:
            if q:
                t = " + " if x > 0 else " - "
                s += "%s%s%s" % (t, c, m)
            else:
                t = "" if x > 0 else "-"
                s = "%s%s%s" % (t, c, m)
                q = True
    if q:
        return s
    else:
        return "0"

for i, p in enumerate(sumpol(10)):
    print(i, ":", polstr(p))
