from math import (comb,
                  factorial)


def lah(n, k):
    if k == 1:
        return factorial(n)
    if k == n:
        return 1
    if k > n:
        return 0
    if k < 1 or n < 1:
        return 0
    return comb(n, k) * factorial(n - 1) // factorial(k - 1)


def main():
    print("Unsigned Lah numbers: L(n, k):")
    print("n/k ", end='\t')
    for i in range(13):
        print("%11d" % i, end='\t')
    print()
    for row in range(13):
        print("%-4d" % row, end='\t')
        for i in range(row + 1):
            l = lah(row, i)
            print("%11d" % l, end='\t')
        print()
    print("\nMaximum value from the L(100, *) row:")
    max_val = max(lah(100, a) for a in range(100))
    print(max_val)


if __name__ == '__main__':
    main()
