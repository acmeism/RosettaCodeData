def dList(n, start):
    start -= 1 # use 0 basing
    a = range(n)
    a[start] = a[0]
    a[0] = start
    a[1:] = sorted(a[1:])
    first = a[1]
    # rescursive closure permutes a[1:]
    r = []
    def recurse(last):
        if (last == first):
            # bottom of recursion. you get here once for each permutation.
            # test if permutation is deranged.
            # yes, save a copy with 1 based indexing
            for j,v in enumerate(a[1:]):
                if j + 1 == v:
                    return # no, ignore it
            b = [x + 1 for x in a]
            r.append(b)
            return
        for i in xrange(last, 0, -1):
            a[i], a[last] = a[last], a[i]
            recurse(last - 1)
            a[i], a[last] = a[last], a[i]
    recurse(n - 1)
    return r

def printSquare(latin,n):
    for row in latin:
        print row
    print

def reducedLatinSquares(n,echo):
    if n <= 0:
        if echo:
            print []
        return 0
    elif n == 1:
        if echo:
            print [1]
        return 1

    rlatin = [None] * n
    for i in xrange(n):
        rlatin[i] = [None] * n
    # first row
    for j in xrange(0, n):
        rlatin[0][j] = j + 1

    class OuterScope:
        count = 0
    def recurse(i):
        rows = dList(n, i)

        for r in xrange(len(rows)):
            rlatin[i - 1] = rows[r]
            justContinue = False
            k = 0
            while not justContinue and k < i - 1:
                for j in xrange(1, n):
                    if rlatin[k][j] == rlatin[i - 1][j]:
                        if r < len(rows) - 1:
                            justContinue = True
                            break
                        if i > 2:
                            return
                k += 1
            if not justContinue:
                if i < n:
                    recurse(i + 1)
                else:
                    OuterScope.count += 1
                    if echo:
                        printSquare(rlatin, n)

    # remaining rows
    recurse(2)
    return OuterScope.count

def factorial(n):
    if n == 0:
        return 1
    prod = 1
    for i in xrange(2, n + 1):
        prod *= i
    return prod

print "The four reduced latin squares of order 4 are:\n"
reducedLatinSquares(4,True)

print "The size of the set of reduced latin squares for the following orders"
print "and hence the total number of latin squares of these orders are:\n"
for n in xrange(1, 7):
    size = reducedLatinSquares(n, False)
    f = factorial(n - 1)
    f *= f * n * size
    print "Order %d: Size %-4d x %d! x %d! => Total %d" % (n, size, n, n - 1, f)
