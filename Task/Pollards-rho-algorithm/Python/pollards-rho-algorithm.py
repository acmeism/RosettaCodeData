import math

def g(x: int, m: int):
    return (x ** 2 + 1) % m

def rho(n: int):
    x = 1
    y = x
    d = 1
    s = 0
    lim = int(math.sqrt(abs(n)))

    while d == 1 and s < lim:
        s += 1
        x = g(x, n)
        y = g(g(y, n), n)
        d = math.gcd(abs(x - y), n)

        if d == n:
            return 0

    return d

def main():
    tests = { 4294967213, 9759463979, 34225158206557151, 13 }

    for i in tests:
        p = rho(i)

        if p == 0:
            print(f"{i} no factor found")

        else:
            print(f"{i} = {p} * {i / p:.0f}")

if __name__ == '__main__':
    main()
