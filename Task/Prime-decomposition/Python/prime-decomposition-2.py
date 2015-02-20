from math import floor, sqrt
try:
    long
except NameError:
    long = int

def fac(n):
    step = lambda x: 1 + (x<<2) - ((x>>1)<<1)
    maxq = long(floor(sqrt(n)))
    d = 1
    q = n % 2 == 0 and 2 or 3
    while q <= maxq and n % q != 0:
        q = step(d)
        d += 1
    return q <= maxq and [q] + fac(n//q) or [n]

if __name__ == '__main__':
    import time
    start = time.time()
    tocalc =  2**59-1
    print("%s = %s" % (tocalc, fac(tocalc)))
    print("Needed %ss" % (time.time() - start))
