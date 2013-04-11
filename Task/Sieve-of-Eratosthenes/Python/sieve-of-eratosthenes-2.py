def eratosthenes2(n):
    multiples = set()
    for i in xrange(2, n+1):
        if i not in multiples:
            print i
            multiples.update(xrange(i*i, n+1, i))

eratosthenes2(100)
