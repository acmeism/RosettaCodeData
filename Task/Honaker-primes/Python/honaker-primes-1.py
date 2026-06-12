''' Rosetta code task: rosettacode.org/wiki/Honaker_primes '''


from pyprimesieve import primes


def digitsum(num):
    ''' Digit sum of an integer (base 10) '''
    return sum(int(c) for c in str(num))


def generate_honaker(limit=5_000_000):
    ''' Generate the sequence of Honaker primes with their sequence and primepi values '''
    honaker = [(i + 1, p) for i, p in enumerate(primes(limit)) if digitsum(p) == digitsum(i + 1)]
    for hcount, (ppi, pri) in enumerate(honaker):
        yield hcount + 1, ppi, pri


print('First 50 Honaker primes:')
for p in generate_honaker():
    if p[0] < 51:
        print(f'{str(p):16}', end='\n' if p[0] % 5 == 0 else '')
    elif p[0] == 10_000:
        print(f'\nThe 10,000th Honaker prime is the {p[1]:,}th one, which is {p[2]:,}.')
        break
