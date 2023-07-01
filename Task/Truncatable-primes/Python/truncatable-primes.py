maxprime = 1000000

def primes(n):
    multiples = set()
    prime = []
    for i in range(2, n+1):
        if i not in multiples:
            prime.append(i)
            multiples.update(set(range(i*i, n+1, i)))
    return prime

def truncatableprime(n):
    'Return a longest left and right truncatable primes below n'
    primelist = [str(x) for x in primes(n)[::-1]]
    primeset = set(primelist)
    for n in primelist:
        # n = 'abc'; [n[i:] for i in range(len(n))] -> ['abc', 'bc', 'c']
        alltruncs = set(n[i:] for i in range(len(n)))
        if alltruncs.issubset(primeset):
            truncateleft = int(n)
            break
    for n in primelist:
        # n = 'abc'; [n[:i+1] for i in range(len(n))] -> ['a', 'ab', 'abc']
        alltruncs = set([n[:i+1] for i in range(len(n))])
        if alltruncs.issubset(primeset):
            truncateright = int(n)
            break
    return truncateleft, truncateright

print(truncatableprime(maxprime))
