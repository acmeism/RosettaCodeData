import operator
from prime_decomposition import decompose

def lcm(a, b):
    if a and b:
        da = list(decompose(abs(a)))
        db = list(decompose(abs(b)))
        merge= da
        for d in da:
            if d in db: db.remove(d)
        merge += db
        return reduce(operator.mul, merge, 1)
    return 0

if __name__ == '__main__':
    print( lcm(12, 18) )    # 36
    print( lcm(-6, 14) )    # 42
    assert lcm(0, 2) == lcm(2, 0) == 0
