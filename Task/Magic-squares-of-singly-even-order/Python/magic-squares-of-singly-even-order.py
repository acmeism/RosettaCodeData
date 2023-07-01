import math
from sys import stdout

LOG_10 = 2.302585092994


# build odd magic square
def build_oms(s):
    if s % 2 == 0:
        s += 1
    q = [[0 for j in range(s)] for i in range(s)]
    p = 1
    i = s // 2
    j = 0
    while p <= (s * s):
        q[i][j] = p
        ti = i + 1
        if ti >= s: ti = 0
        tj = j - 1
        if tj < 0: tj = s - 1
        if q[ti][tj] != 0:
            ti = i
            tj = j + 1
        i = ti
        j = tj
        p = p + 1

    return q, s


# build singly even magic square
def build_sems(s):
    if s % 2 == 1:
        s += 1
    while s % 4 == 0:
        s += 2

    q = [[0 for j in range(s)] for i in range(s)]
    z = s // 2
    b = z * z
    c = 2 * b
    d = 3 * b
    o = build_oms(z)

    for j in range(0, z):
        for i in range(0, z):
            a = o[0][i][j]
            q[i][j] = a
            q[i + z][j + z] = a + b
            q[i + z][j] = a + c
            q[i][j + z] = a + d

    lc = z // 2
    rc = lc
    for j in range(0, z):
        for i in range(0, s):
            if i < lc or i > s - rc or (i == lc and j == lc):
                if not (i == 0 and j == lc):
                    t = q[i][j]
                    q[i][j] = q[i][j + z]
                    q[i][j + z] = t

    return q, s


def format_sqr(s, l):
    for i in range(0, l - len(s)):
        s = "0" + s
    return s + " "


def display(q):
    s = q[1]
    print(" - {0} x {1}\n".format(s, s))
    k = 1 + math.floor(math.log(s * s) / LOG_10)
    for j in range(0, s):
        for i in range(0, s):
            stdout.write(format_sqr("{0}".format(q[0][i][j]), k))
        print()
    print("Magic sum: {0}\n".format(s * ((s * s) + 1) // 2))


stdout.write("Singly Even Magic Square")
display(build_sems(6))
