from sympy import isprime

def is_mpn(n: int):
    first = second = 0

    delta = 1 + (n & 1)
    d = delta + 1

    while d * d <= n:
        if n % d == 0:
            if second != 0:
                return False

            first = d
            q = n // d

            if q != d:
                second = q

        d += delta

    return first * second == n

def main():
    count = 0

    for n in range(1, 500):
        if is_mpn(n):
            count += 1
            print("%3d" % n, end=' ')

            if count % 10 == 0:
                print()

    print('\n')

    mpn_count = 0
    limit = 500
    ns = nc = 3
    squares = cubes = 1
    n = 1

    while True:
        n += 1

        if n == limit:
            while ns * ns < limit:
                if isprime(ns):
                    squares += 1
                ns += 2

            while nc ** 3 < limit:
                if isprime(nc):
                    cubes += 1
                nc += 2

            print(f"Under {limit} there are {mpn_count} MPNs and {mpn_count - cubes + squares} semi-primes.")

            if limit == 500_000:
                break

            limit *= 10

        if is_mpn(n):
            mpn_count += 1

if __name__ == '__main__':
    main()
