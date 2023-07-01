def digital_root (n):
    ap = 0
    n = abs(int(n))
    while n >= 10:
        n = sum(int(digit) for digit in str(n))
        ap += 1
    return ap, n

if __name__ == '__main__':
    for n in [627615, 39390, 588225, 393900588225, 55]:
        persistance, root = digital_root(n)
        print("%12i has additive persistance %2i and digital root %i."
              % (n, persistance, root))
