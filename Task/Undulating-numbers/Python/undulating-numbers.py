from sympy import isprime
from collections import deque

def to_base(n: int, base: int):
    digits = deque()

    while n > 0:
        digits.appendleft(str(n % base))
        n //= base

    return int(''.join(digits))

def t_print(nums: list[int], cols: int):
    for i, n in enumerate(nums):
        if i % cols == 0 and i != 0:
            print()

        print('%d' % n, end=' ')

    print()

def undulating(base: int, n: int):
    mpow = 53
    limit = pow(2, mpow) - 1
    u3 = []
    u4 = []
    bsquare = base * base

    for a in range(1, base):
        for b in range(0, base):
            if (b == a):
                continue

            u = a * bsquare + b * base + a
            u3.append(u)
            v = a * base + b
            u4.append(v * bsquare + v)

    print(f"All 3 digit undulating numbers in base {base}:")
    t_print(u3, 9)
    print(f"\nAll 4 digit undulating numbers in base {base}:")
    t_print(u4, 9)
    print(f"\nAll 3 digit undulating numbers which are primes in base {base}:")

    primes = [
        u
        for u in u3
        if u % 2 == 1 and u % 5 != 0 and isprime(u)
    ]

    t_print(primes, 9)
    un = u3 + u4
    unc = len(un)
    j = 0
    done = False

    while True:
        for i in range(0, unc):
            u = un[j * unc + i] * bsquare + un[j * unc + i] % bsquare

            if u > limit:
                done = True
                break

            un.append(u)

        if done:
            break

        j += 1

    print("\nThe {:,} undulating number in base {:} is: {:,}".format(n, base, un[n-1]))

    if (base != 10):
        print("or expressed in base {:} : {:,}".format(base, to_base(un[n-1], base)))

    print("\nTotal number of undulating numbers in base {:} < {:} = {:,} ".format(base, mpow, len(un)), end='')
    print("of which the largest is: {:,}".format(un[-1]))

    if (base != 10):
        print("or expressed in base {:} : {:,}".format(base, to_base(un[-1], base)))

def main():
    for base in [10, 7]:
        undulating(base, 600)

if __name__ == '__main__':
    main()
