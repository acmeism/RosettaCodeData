try:
    import psyco
    psyco.full()
except ImportError:
    pass

MAX_N = 300
BRANCH = 4

ra = [0] * MAX_N
unrooted = [0] * MAX_N

def tree(br, n, l, sum = 1, cnt = 1):
    global ra, unrooted, MAX_N, BRANCH
    for b in xrange(br + 1, BRANCH + 1):
        sum += n
        if sum >= MAX_N:
            return

        # prevent unneeded long math
        if l * 2 >= sum and b >= BRANCH:
            return

        if b == br + 1:
            c = ra[n] * cnt
        else:
            c = c * (ra[n] + (b - br - 1)) / (b - br)

        if l * 2 < sum:
            unrooted[sum] += c

        if b < BRANCH:
            ra[sum] += c;
            for m in range(1, n):
                tree(b, m, l, sum, c)

def bicenter(s):
    global ra, unrooted
    if not (s & 1):
        aux = ra[s / 2]
        unrooted[s] += aux * (aux + 1) / 2


def main():
    global ra, unrooted, MAX_N
    ra[0] = ra[1] = unrooted[0] = unrooted[1] = 1

    for n in xrange(1, MAX_N):
        tree(0, n, n)
        bicenter(n)
        print "%d: %d" % (n, unrooted[n])

main()
