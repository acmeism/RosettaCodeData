# Highest power of two that divides a given number.
def hpo2(n): return n & (-n)

# Base 2 logarithm of the highest power of 2 dividing a given number.
def lhpo2(n):
    q = 0
    m = hpo2(n)
    while m%2 == 0:
        m = m >> 1
        q += 1
    return q

def nimsum(x,y): return x ^ y

def nimprod(x,y):
    if x < 2 or y < 2:
        return x * y
    h = hpo2(x)
    if x > h:
        return nimprod(h, y) ^ nimprod(x^h, y) # break x into powers of 2
    if hpo2(y) < y:
        return nimprod(y, x) # break y into powers of 2 by flipping operands
    xp, yp = lhpo2(x), lhpo2(y)
    comp = xp & yp
    if comp == 0:
        return x * y # no Fermat power in common
    h = hpo2(comp)
    # a Fermat number square is its sequimultiple
    return nimprod(nimprod(x>>h, y>>h), 3<<(h-1))

if __name__ == '__main__':
    for f, op in ((nimsum, '+'), (nimprod, '*')):
        print(f" {op} |", end='')
        for i in range(16):
            print(f"{i:3d}", end='')
        print("\n--- " + "-"*48)
        for i in range(16):
            print(f"{i:2d} |", end='')
            for j in range(16):
                print(f"{f(i,j):3d}", end='')
            print()
        print()

    a, b = 21508, 42689
    print(f"{a} + {b} = {nimsum(a,b)}")
    print(f"{a} * {b} = {nimprod(a,b)}")
