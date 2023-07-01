# k-Almost-primes
# Python 3.6.3
# no imports
# author: manuelcaeiro | https://github.com/manuelcaeiro

def prime_factors(m=2):

    for i in range(2, m):
        r, q = divmod(m, i)
        if not q:
            return [i] + prime_factors(r)
    return [m]

def k_almost_primes(n, k=2):
    multiples = set()
    lists = list()
    for x in range(k+1):
        lists.append([])

    for i in range(2, n+1):
        if i not in multiples:
            if len(lists[1]) < 10:
                lists[1].append(i)
            multiples.update(range(i*i, n+1, i))
    print("k=1: {}".format(lists[1]))

    for j in range(2, k+1):
        for m in multiples:
            l = prime_factors(m)
            ll = len(l)
            if ll == j and len(lists[j]) < 10:
                lists[j].append(m)

        print("k={}: {}".format(j, lists[j]))

k_almost_primes(200, 5)
# try:
#k_almost_primes(6000, 10)
