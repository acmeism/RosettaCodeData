def iprimes_upto(limit):
    is_prime = [False] * 2 + [True] * (limit - 1)
    for n in range(limit + 1):
        if is_prime[n]:
            yield n
            for i in range(n*n, limit+1, n): # start at ``n`` squared
                is_prime[i] = False
