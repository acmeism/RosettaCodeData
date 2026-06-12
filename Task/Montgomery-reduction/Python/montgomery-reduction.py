#!/usr/bin/python3

class Montgomery:
    BASE = 2

    def __init__(self, m):
        self.m = m
        self.n = m.bit_length()
        self.r = (1 << self.n)
        self.rrm = (self.r * self.r) % m

    def reduce(self, t):
        a = t
        for _ in range(self.n):
            if (a & 1) == 1:
                a += self.m
            a >>= 1

        if a >= self.m:
            a -= self.m
        return a

if __name__ == "__main__":
    m = 750791094644726559640638407699
    x1 = 540019781128412936473322405310
    x2 = 515692107665463680305819378593

    mont = Montgomery(m)

    t1 = x1 * mont.rrm
    t2 = x2 * mont.rrm
    r1 = mont.reduce(t1)
    r2 = mont.reduce(t2)

    print(
        f" b: {Montgomery.BASE}\n"
        f" n: {mont.n}\n"
        f" r: {mont.r}\n"
        f" m: {mont.m}\n"
        f"t1: {t1}\n"
        f"t2: {t2}\n"
        f"r1: {r1}\n"
        f"r2: {r2}\n"
        f"Original x1       : {x1}\n"
        f"Recovered from r1 : {mont.reduce(r1)}\n"
        f"Original x2       : {x2}\n"
        f"Recovered from r2 : {mont.reduce(r2)}\n"
    )

    prod = mont.reduce(mont.rrm)  # Inicializar con 1 en formato Montgomery
    base = mont.reduce(x1 * mont.rrm)
    exp = x2

    while exp > 0:
        if exp & 1:
            prod = mont.reduce(prod * base)
        exp >>= 1
        base = mont.reduce(base * base)

    resultado_montgomery = mont.reduce(prod)
    resultado_python = pow(x1, x2, m)

    print(f"\nMontgomery computation of x1 ^ x2 mod m:\n{resultado_montgomery}")
    print(f"\nAlternate computation of x1 ^ x2 mod m: \n{pow(x1, x2, m)}")
