def eratosthenes(n):
    multiples = []
    for i in xrange(2, n+1):
        if i not in multiples:
            print i
            multiples.extend(xrange(i*i, n+1, i))

eratosthenes(100)
