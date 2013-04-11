def eratosthenes(n):
    multiples = []
    for i in xrange(2, n+1):
        if i not in multiples:
            print i
            for j in xrange(i*i, n+1, i):
                multiples.append(j)

eratosthenes(100)
