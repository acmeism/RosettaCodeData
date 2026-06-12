import math

NBITS = 8
ES = 2
NPAT = 1 << NBITS
USEED = 1 << (1 << ES)

def x2p(x: float):
    e = 1 << (ES - 1)
    y = abs(x)

    if y == 0:
        return 0

    if y == float('inf'):
        return 1 << (NBITS - 1)

    if y >= 1:
        p = 1
        i = 2

        while y >= USEED and i < NBITS:
            p = 2 * p + 1
            y /= USEED
            i += 1

        p = 2 * p
        i += 1

    else:
        p = 0
        i = 1

        while y < 1 and i <= NBITS:
            y *= USEED
            i += 1

        if i >= NBITS:
            p = 2
            i = NBITS + 1

    while e > 0.5 and i <= NBITS:
        p *= 2

        if y >= 2 * e:
            y /= (1 << int(e))
            p += 1

        e /= 2
        i += 1

    y -= 1

    while y > 0 and i <= NBITS:
        y *= 2
        p = 2 * p + math.floor(y)
        y -= math.floor(y)
        i += 1

    p *= (1 << (NBITS + 1 - i))
    i += 1
    i = p & 1
    p = p // 2

    if i != 0:
        if y == 1 or y == 0:
            p += p & 1
        else:
            p += 1

    num = NPAT - p if x < 0 else p

    return num % NPAT

def main():
    print(x2p(math.pi))

if __name__ == '__main__':
    main()
