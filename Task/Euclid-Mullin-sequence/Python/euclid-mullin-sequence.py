""" Rosetta code task: Euclid-Mullin_sequence """

from primePy import primes

def euclid_mullin():
    """ generate Euclid-Mullin sequence """
    total = 1
    while True:
        next_iter = primes.factor(total + 1)
        total *= next_iter
        yield next_iter

GEN = euclid_mullin()
print('First 16 Euclid-Mullin numbers:', ', '.join(str(next(GEN)) for _ in range(16)))
