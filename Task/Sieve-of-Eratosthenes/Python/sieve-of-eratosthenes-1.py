def eratosthenes2(n):
    multiples = set()
    for i in range(2, n+1):
        if i not in multiples:
            print(i)
            multiples.update(range(i*i, n+1, i))

eratosthenes2(100)
