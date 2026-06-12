def bits(n):
    """Count the amount of bits required to represent n"""
    r = 0
    while n:
        n >>= 1
        r += 1
    return r

def concat(n):
    """Concatenate the binary representation of n to itself"""
    return n << bits(n) | n

n = 1
while concat(n) <= 1000:
    print("{0}: {0:b}".format(concat(n)))
    n += 1
