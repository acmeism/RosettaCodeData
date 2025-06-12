from math import sqrt, gcd

M = [1, 3, 5, 7, 11]
UINT64_MAX = 18446744073709551615

def isqrt(n: int):
    return int(sqrt(n))

def squfof(n: int):
    if n % 2 == 0:
        return 2

    h = int(sqrt(n) + 0.5)

    if h ** 2 == n:
        return h

    for m in M:
        if m > 1 and n % m == 0:
            return m

        if n > UINT64_MAX / m:
            break

        mn = m * n
        r = isqrt(mn)

        if r ** 2 > mn:
            r -= 1

        rn = r

        b = r
        a = 1
        h = ((rn + b) // a) * a - b
        c = (mn - h * h) // a

        for i in range(2, 4 * isqrt(2 * r)):
            a, c = c, a
            q = (rn + b) // a
            t = b
            b = q * a - b
            c += q * (t - b)

            if i % 2 == 0:
                r = int(sqrt(c) + 0.5)

                if r ** 2 == c:
                    q = (rn - b) // r
                    v = q * r + b
                    w = (mn - v * v) // r

                    u = r

                    while True:
                        w, u = u, w
                        r = v
                        q = (rn + v) // u
                        v = q * u - v

                        if v == r:
                            break

                        w += q * (r - v)

                    h = gcd(n, u)

                    if h != 1:
                        return h

    return 1

data = [
    2501,
    12851,
    13289,
    75301,
    120787,
    967009,
    997417,
    7091569,
    13290059,
    42854447,
    223553581,
    2027651281,
    11111111111,
    100895598169,
    1002742628021,
    60012462237239,
    287129523414791,
    9007199254740931,
    11111111111111111,
    314159265358979323,
    384307168202281507,
    419244183493398773,
    658812288346769681,
    922337203685477563,
    1000000000000000127,
    1152921505680588799,
    1537228672809128917,
    4611686018427387877
]

print("N                      f          N/f")
print("======================================")

for n in data:
    f = squfof(n)
    res = 'fail' if f == 1 else f'{f:<10} {n // f}'
    print(f'{n:<22} {res}')
