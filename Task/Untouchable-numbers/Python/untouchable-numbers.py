def prime_sieve(limit: int):
    p = 3

    limit += 1

    c = [False] * limit

    c[0] = True
    c[1] = True

    for i in range(4, limit, 2):
        c[i] = True

    while True:
        p2 = p * p

        if p2 >= limit:
            break

        for i in range(p2, limit, 2 * p):
            c[i] = True

        while True:
            p += 2

            if not c[p]:
                break

    return c

def main():
    limit = 1000000

    uc = 2
    p = 10
    m = 63
    ul = 151000

    c = prime_sieve(limit)
    n = m * limit + 1

    sum_divs = [0] * n

    for i in range(1, n):
        for j in range(i, n, i):
            sum_divs[j] += i

    s = [False] * n

    for i in range(1, n):
        sumation = sum_divs[i] - i
        if sumation <= n:
            s[sumation] = True

    untouchable = [0] * ul

    untouchable[0] = 2
    untouchable[1] = 5

    for n in range(6, limit+1, 2):
        if not s[n] and c[n - 1] and c[n-3]:
            untouchable[uc] = n
            uc += 1

    print("List of untouchable numbers <= 2,000:")

    for i in range(uc):
        j = untouchable[i]

        if j > 2000:
            break

        print("%3d " % j, end=' ')

        if not ((i+1) % 10):
            print()

    print("\n\n%d untouchable numbers were found  <=     2,000\n" % i)

    for i in range(uc):
        j = untouchable[i]

        if j > p:
            print("%d untouchable numbers were found  <= %d\n" % (i, p))
            p *= 10

            if p == limit:
                break

    print("%d untouchable numbers were found  <= %d" % (uc, limit))

if __name__ == '__main__':
    main()
