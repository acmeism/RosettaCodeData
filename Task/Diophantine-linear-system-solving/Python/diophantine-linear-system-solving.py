""" "rosettacode.org/wiki/Diophantine_linear_system_solving """

import math
from dataclasses import dataclass
from re import split
from typing import List

# if ECHO is True will print additional calculation information for debugging
ECHO = False

# Constants: alpha is ALN / ALD, 0.25 < alpha < 1.0
ALN = 80
ALD = 81


@dataclass
class MinusOneBasedVector:
    """ -1 based vector of floats """
    data: List[float]


@dataclass
class Matrix:
    """ matrix of floats """
    data: List[List[float]]


def new_MinusOneBasedVector(n: int) -> MinusOneBasedVector:
    """ set up the d MinusOneBasedVector of proper size for its -1 base indexing """
    return MinusOneBasedVector(data=[0.0] * (n + 2))


def new_matrix(m: int, n: int) -> Matrix:
    """ set up matrix of proper size """
    return Matrix(data=[[0.0] * (n + 1) for _ in range(m + 1)])


def MinusOneBasedVector_get(v: MinusOneBasedVector, i: int) -> float:
    """  compensation for BASIC code's -1 based indexing of d MinusOneBasedVector """
    return v.data[i + 1]


def MinusOneBasedVector_set(v: MinusOneBasedVector, i: int, value: float) -> None:
    """ set for d MinusOneBasedVector with compensation for oddball indexing on d MinusOneBasedVector"""
    v.data[i + 1] = value


def input_prompt(prompt: str) -> str:
    """ prompt for and get input from stdin, stripping line gotten """
    return input(prompt).strip()


def inp_const(pr: int, m1: int, m: int, a: Matrix, lines: list[str]) -> None:
    """ input (real or complex) data to solve finding polynomial with value of const """
    m2 = m1 + 1
    g = lines.pop(0) if lines else input_prompt(" a + bi: ")
    parts = g.split()

    try:
        x = float(parts[0])
        y = 0.0
        if len(parts) > 1:
            op = parts[1]
            y = float(parts[2].rstrip('i')) if op == '+' else - \
                float(parts[2].rstrip('i'))
    except (ValueError, IndexError) as exc:
        raise ValueError("wrong complex number") from exc

    print(f"({x}, {y}i)")

    a.data[0][m1] = 1
    p = 10.0 ** pr
    a.data[1][m1] = p
    q = 0.0

    for r in range(2, m):
        t = p
        p = p * x - q * y
        q = t * y + q * x
        a.data[r][m1] = round(p)
        a.data[r][m2] = round(q)


def inp_sys(n: int, m: int, m1: int, a: Matrix, lines: list[str]) -> bool:
    """ input integer matrix data to solve a matrix Diophantine linear system problem """
    sw = False
    for r in range(n):
        g = lines.pop(0) if lines else input_prompt(
            f" row A{r + 1} and b{r + 1} ").strip()
        sw = sw or any(c in g for c in './')  # reject fractional coefficients
        tokens = [t for t in split(r'[|\s]', g) if t]
        for s, token in enumerate(tokens):
            if s > m:
                print("Ignoring extra characters.")
                break
            a.data[s][m1 + r] = float(token)
    if sw:
        print("illegal input")
    return sw


def prow(r: int, m1: int, mn: int, a: Matrix, l: List[List[int]], p: List[int]) -> None:
    """ print matrix row """
    for s in range(mn + 1):
        if s == m1:
            print(" |", end="")
        print(" " * (p[s] - l[r][s] + 1), end="")
        print(int(a.data[r][s]), end="")


def print_m(sw: bool, m: int, m1: int, mn: int, a: Matrix) -> None:
    """ print matrix from problem """
    l = [[len(str(int(a.data[r][s]))) for s in range(mn + 1)]
         for r in range(m + 1)]
    p = [1] * (mn + 1)
    for s in range(mn + 1):
        for r in range(m + 1):
            p[s] = max(p[s], l[r][s])

    if sw:
        print("P | Hnf")
        k = 0
        for r in range(m + 1):
            if a.data[r][mn] != 0:
                k = r
                break
        sw = a.data[k][mn] == 1
        for s in range(m1, mn):
            sw = sw and a.data[k][s] == 0
        g = "  -solution" if sw else "   inconsistent"
        for s in range(m):
            sw = sw and a.data[k][s] == 0
        if sw:
            g = ""

        for r in range(m, k - 1, -1):
            prow(r, m1, mn, a, l, p)
            print(g if r == k else "")
        for r in range(k):
            prow(r, m1, mn, a, l, p)
            q = sum(a.data[r][s] ** 2 for s in range(m))
            print(f"   ({int(q)})")
    else:
        print("I | Ab~")
        for r in range(m + 1):
            prow(r, m1, mn, a, l, p)


def minus(t: int, m: int, mn: int, a: Matrix, la: Matrix) -> None:
    """ negate rows t of matrix a and rows and cols t of matrix la """
    for s in range(mn + 1):
        a.data[t][s] = -a.data[t][s]
    for r in range(1, m + 1):
        for s in range(r):
            if r == t or s == t:
                la.data[r][s] = -la.data[r][s]


def reduce(
        k: int,
        t: int,
        m: int,
        m1: int,
        mn: int,
        nx: int,
        a: Matrix,
        la: Matrix,
        d: MinusOneBasedVector) -> tuple[int, int]:
    """ LLL reduction """
    c1 = nx
    c2 = nx
    for s in range(m1, mn + 1):
        if a.data[t][s] != 0:
            c1 = s
            break
    for s in range(m1, mn + 1):
        if a.data[k][s] != 0:
            c2 = s
            break

    q = 0.0
    if c1 < nx:
        if a.data[t][c1] < 0:
            minus(t, m, mn, a, la)
        q = math.floor(a.data[k][c1] / a.data[t][c1])
    else:
        lk = la.data[k][t]
        if 2 * abs(lk) > MinusOneBasedVector_get(d, t):
            q = round(lk / MinusOneBasedVector_get(d, t))

    if q != 0:
        sx = m if c1 == nx else mn
        for s in range(sx + 1):
            a.data[k][s] -= q * a.data[t][s]
        la.data[k][t] -= q * MinusOneBasedVector_get(d, t)
        for s in range(t):
            la.data[k][s] -= q * la.data[t][s]

    return c1, c2


def swop(k: int, m: int, mn: int, a: Matrix, la: Matrix, d: MinusOneBasedVector) -> None:
    """ exchange rows k and k - 1 """
    t = k - 1
    for s in range(mn + 1):
        a.data[k][s], a.data[t][s] = a.data[t][s], a.data[k][s]
    for s in range(t):
        la.data[k][s], la.data[t][s] = la.data[t][s], la.data[k][s]

    lk = la.data[k][t]
    db = (MinusOneBasedVector_get(d, t - 1) * MinusOneBasedVector_get(d, k) + lk * lk) / MinusOneBasedVector_get(d, t)
    for r in range(k + 1, m + 1):
        lr = la.data[r][k]
        la.data[r][k] = (MinusOneBasedVector_get(d, k) * la.data[r]
                         [t] - lk * lr) / MinusOneBasedVector_get(d, t)
        la.data[r][t] = (db * lr + lk * la.data[r][k]) / MinusOneBasedVector_get(d, k)
    MinusOneBasedVector_set(d, t, db)


def main(
        sw: int,
        m: int,
        m1: int,
        mn: int,
        n: int,
        nx: int,
        a: Matrix,
        la: Matrix,
        d: MinusOneBasedVector,
        lines) -> None:
    """ input problem from rows as text or from stdin, solve, then print the solution """
    if sw != 0:
        inp_const(sw, m1, m, a, lines)
    elif inp_sys(n, m, m1, a, lines):
        return

    a.data[m][mn] = 1
    for i in range(m + 1):
        a.data[i][i] = 1
    for i in range(-1, m + 1):
        MinusOneBasedVector_set(d, i, 1)

    if ECHO:
        print_m(False, m, m1, mn, a)

    k = 1
    tl = 0
    while k <= m:
        t = k - 1
        c1, c2 = reduce(k, t, m, m1, mn, nx, a, la, d)

        sw = (c1 == nx and c2 == nx)
        if sw:
            lk = la.data[k][t]
            db = MinusOneBasedVector_get(d, t - 1) * MinusOneBasedVector_get(d, k) + lk * lk
            sw = db * ALD < MinusOneBasedVector_get(d, t) * MinusOneBasedVector_get(d, t) * ALN

        if sw or (c1 <= c2 and c1 < nx):
            swop(k, m, mn, a, la, d)
            if k > 1:
                k -= 1
        else:
            for i in range(t - 1, -1, -1):
                reduce(k, i, m, m1, mn, nx, a, la, d)
            k += 1
        tl += 1

    print_m(True, m, m1, mn, a)
    print(f"loop {tl}")


if __name__ == "__main__":
    def test_lattice(text: str = ""):
        """ test the program """
        lines = [s.strip() for s in text.split('\n')] if text else []

        while True:
            print()
            sw = 0
            while True:
                g = lines.pop(0) if lines else input_prompt(" rows ")
                if not g.startswith("'"):
                    break
                print(g)
                if "const" in g:
                    sw = 1
            try:
                n = int(g)
            except ValueError:
                break
            if n < 1:
                break

            g = lines.pop(0) if lines else input_prompt(" cols ")
            try:
                m = int(g)
            except ValueError:  # drain lines to next problem entry
                for _ in range(n):
                    g = lines.pop(0) if lines else input_prompt("")
                continue
            if m < 1:
                for _ in range(n):
                    g = lines.pop(0) if lines else input_prompt("")
                continue

            if sw != 0:
                sw = n - 1
                n = 2
                m += 2
            m1 = m + 1
            mn = m1 + n
            nx = mn + 1
            la = new_matrix(m, m)
            d = new_MinusOneBasedVector(m)
            a = new_matrix(m, mn)

            if ECHO:
                print("\033[2J\033[H", end="")  # Clear screen
            main(sw, m, m1, mn, n, nx, a, la, d, lines)
            print()

    TEST_TEXT = """
    'five base cases
    'no integral solution
    2
    2
    2 0| 1
    2 1| 2
    'indeterminate
    2
    3
    1  3  5
    4  6  8
    'singular square
    3
    3
    1  7  4
    2  8  5
    3  9  6
    'overdetermined
    3
    2
    2  1| 2
    6  5| 2
    7  6| 2
    'square
    3
    3
    2 -3  4| 9
    5  6  7| 3
    8  9 10| 3
    'Hnf(A) with Aij = i^3 * j^2 + i + j (example 7.4)
    10
    10
    3  11   31   69   131   223   351   521   739   1011
    7  36  113  262   507   872  1381  2058  2927   4012
    13  77  249  583  1133  1953  3097  4619  6573   9013
    21 134  439 1032  2009  3466  5499  8204 11677  16014
    31 207  683 1609  3135  5411  8587 12813 18239  25015
    43 296  981 2314  4511  7788 12361 18446 26259  36016
    57 401 1333 3147  6137 10597 16821 25103 35737  49017
    73 522 1739 4108  8013 13838 21967 32784 46673  64018
    91 659 2199 5197 10139 17511 27799 41489 59067  81019
    111 812 2713 6414 12515 21616 34317 51218 72919 100020
    'Gauss x*atan(1/239) + y*atan(1/57) + z*atan(1/18) = pi/4
    '(fudge factor -1 to absorb round-off error
    ' ignore the corresponding MinusOneBasedVector entry x1)
    1
    4
    -1 0041841 0175421 0554985| 7853982
    'search for polynomial coefficients
    'const sqrt(2) + i
    4
    4
    1.41421356 + 1
    'const 3^(1/3) + sqrt(2)
    11
    6
    2.8564631326805
    'some constant
    12
    9
    -1.4172098692728
    0
    0
    """
    test_lattice(TEST_TEXT.strip())

