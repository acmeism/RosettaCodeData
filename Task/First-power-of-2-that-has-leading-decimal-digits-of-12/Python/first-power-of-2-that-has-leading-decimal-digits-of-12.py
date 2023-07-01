from math import log, modf, floor

def p(l, n, pwr=2):
    l = int(abs(l))
    digitcount = floor(log(l, 10))
    log10pwr = log(pwr, 10)
    raised, found = -1, 0
    while found < n:
        raised += 1
        firstdigits = floor(10**(modf(log10pwr * raised)[0] + digitcount))
        if firstdigits == l:
            found += 1
    return raised


if __name__ == '__main__':
    for l, n in [(12, 1), (12, 2), (123, 45), (123, 12345), (123, 678910)]:
        print(f"p({l}, {n}) =", p(l, n))
