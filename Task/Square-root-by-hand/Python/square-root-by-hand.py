import math

def main():
    i = 2
    j = int(math.sqrt(2))
    k = d = j
    n0 = n = 500

    while True:
        print(d, end='')
        i = (i - k * d) * 100
        k = 20 * j
        d = 1

        while d <= 10:
            if (k + d) * d > i:
                d -= 1
                break

            d += 1

        j = j * 10 + d
        k += d

        if n0 > 0:
            n -= 1

        if n == 0:
            break

if __name__ == '__main__':
    main()
