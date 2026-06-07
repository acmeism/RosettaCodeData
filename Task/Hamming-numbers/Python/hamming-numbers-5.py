from heapq import merge
from itertools import tee, islice

def hamming_numbers():
    last = 1
    yield last

    a, b, c = tee(hamming_numbers(), 3)

    for n in merge((2*i for i in a), (3*i for i in b), (5*i for i in c)):
        if n != last:
            yield n
            last = n

print(list(islice(hamming_numbers(), 20)))
print(next(islice(hamming_numbers(), 1690, 1691)))
