from math import floor, sqrt
try:
    long
except NameError:
    long = int

def fac(n):
    step = lambda x: 1 + x*4 - (x//2)*2
    maxq = long(floor(sqrt(n)))
    d = 1
    q = n % 2 == 0 and 2 or 3
    while q <= maxq and n % q != 0:
        q = step(d)
        d += 1
    res = []
    if q <= maxq:
        res.extend(fac(n//q))
        res.extend(fac(q))
    else: res=[n]
    return res

if __name__ == '__main__':
    import time
    start = time.time()
    tocalc =  2**59-1
    print("%s = %s" % (tocalc, fac(tocalc)))
    print("Needed %ss" % (time.time() - start))
