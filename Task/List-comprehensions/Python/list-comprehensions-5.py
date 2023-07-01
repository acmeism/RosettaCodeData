def triplets(n):
    for x in xrange(1, n + 1):
        for y in xrange(x, n + 1):
            for z in xrange(y, n + 1):
                yield x, y, z
