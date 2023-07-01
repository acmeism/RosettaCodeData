from itertools import count
def lgen(even=False):
    lucky = []
    if not even:
        yield 1
    for k in count(1):
        for l in reversed(lucky):
            k = (k*l)//(l-1)
        lucky.append(2*k+1 + even)
        yield 2*k+1 + even
