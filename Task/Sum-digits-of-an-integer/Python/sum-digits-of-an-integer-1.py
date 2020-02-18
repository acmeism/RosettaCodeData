from numpy import base_repr

def sumDigits(num, base=10):
    return sum(int(x, base) for x in list(base_repr(num, base)))
