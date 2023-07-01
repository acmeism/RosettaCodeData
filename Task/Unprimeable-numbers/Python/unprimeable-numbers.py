from itertools import count, islice

def primes(_cache=[2, 3]):
    yield from _cache
    for n in count(_cache[-1]+2, 2):
        if isprime(n):
            _cache.append(n)
            yield n

def isprime(n, _seen={0: False, 1: False}):
    def _isprime(n):
        for p in primes():
            if p*p > n:
                return True
            if n%p == 0:
                return False

    if n not in _seen:
        _seen[n] = _isprime(n)
    return _seen[n]

def unprime():
    for a in count(1):
        d = 1
        while d <= a:
            base = (a//(d*10))*(d*10) + (a%d) # remove current digit
            if any(isprime(y) for y in range(base, base + d*10, d)):
                break
            d *= 10
        else:
            yield a


print('First 35:')
print(' '.join(str(i) for i in islice(unprime(), 35)))

print('\nThe 600-th:')
print(list(islice(unprime(), 599, 600))[0])
print()

first, need = [False]*10, 10
for p in unprime():
    i = p%10
    if first[i]: continue

    first[i] = p
    need -= 1
    if not need:
        break

for i,v in enumerate(first):
    print(f'{i} ending: {v}')
