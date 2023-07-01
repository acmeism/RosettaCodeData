def ludic(nmax=100000):
    yield 1
    lst = list(range(2, nmax + 1))
    while lst:
        yield lst[0]
        del lst[::lst[0]]

ludics = [l for l in ludic()]

print('First 25 ludic primes:')
print(ludics[:25])
print("\nThere are %i ludic numbers <= 1000"
      % sum(1 for l in ludics if l <= 1000))
print("\n2000'th..2005'th ludic primes:")
print(ludics[2000-1: 2005])

n = 250
triplets = [(x, x+2, x+6)
            for x in ludics
            if x+6 < n and x+2 in ludics and x+6 in ludics]
print('\nThere are %i triplets less than %i:\n  %r'
      % (len(triplets), n, triplets))
