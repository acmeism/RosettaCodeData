from itertools import count, chain
from collections import deque

def primes(_cache=[2, 3]):
    yield from _cache
    for n in count(_cache[-1]+2, 2):
        if isprime(n):
            _cache.append(n)
            yield n

def isprime(n):
    for p in primes():
        if n%p == 0:
            return False
        if p*p > n:
            return True

def factors(n):
    for p in primes():
    # prime factoring is such a non-issue for small numbers that, for
    # this example, we might even just say
    # for p in count(2):
        if p*p > n:
            if n > 1:
                yield(n, 1, 1)
            break

        if n%p == 0:
            cnt = 0
            while True:
                n, cnt = n//p, cnt+1
                if n%p != 0: break
            yield p, cnt, n
# ^^ not the most sophisticated prime number routines, because no need

# Returns (list1, list2) representing the division between
# two polinomials. A list p of integers means the product
#   (x^p[0] - 1) * (x^p[1] - 1) * ...
def cyclotomic(n):
    def poly_div(num, den):
        return (num[0] + den[1], num[1] + den[0])

    def elevate(poly, n): # replace poly p(x) with p(x**n)
        powerup = lambda p, n: [a*n for a in p]
        return poly if n == 1 else (powerup(poly[0], n), powerup(poly[1], n))


    if n == 0:
        return ([], [])
    if n == 1:
        return ([1], [])

    p, m, r = next(factors(n))
    poly = cyclotomic(r)
    return elevate(poly_div(elevate(poly, p), poly), p**(m-1))

def to_text(poly):
    def getx(c, e):
        if e == 0:
            return '1'
        elif e == 1:
            return 'x'
        return 'x' + (''.join('⁰¹²³⁴⁵⁶⁷⁸⁹'[i] for i in map(int, str(e))))

    parts = []
    for (c,e) in (poly):
        if c < 0:
            coef = ' - ' if c == -1 else f' - {-c} '
        else:
            coef = (parts and ' + ' or '') if c == 1 else f' + {c}'
        parts.append(coef + getx(c,e))
    return ''.join(parts)

def terms(poly):
    # convert above representation of division to (coef, power) pairs

    def merge(a, b):
        # a, b should be deques. They may change during the course.
        while a or b:
            l = a[0] if a else (0, -1) # sentinel value
            r = b[0] if b else (0, -1)
            if l[1] > r[1]:
                a.popleft()
            elif l[1] < r[1]:
                b.popleft()
                l = r
            else:
                a.popleft()
                b.popleft()
                l = (l[0] + r[0], l[1])
            yield l

    def mul(poly, p): # p means polynomial x^p - 1
        poly = list(poly)
        return merge(deque((c, e+p) for c,e in poly),
                     deque((-c, e) for c,e in poly))

    def div(poly, p): # p means polynomial x^p - 1
        q = deque()
        for c,e in merge(deque(poly), q):
            if c:
                q.append((c, e - p))
                yield (c, e - p)
            if e == p: break

    p = [(1, 0)]  # 1*x^0, i.e. 1

    for x in poly[0]: # numerator
        p = mul(p, x)
    for x in sorted(poly[1], reverse=True): # denominator
        p = div(p, x)
    return p

for n in chain(range(11), [2]):
    print(f'{n}: {to_text(terms(cyclotomic(n)))}')

want = 1
for n in count():
    c = [c for c,_ in terms(cyclotomic(n))]
    while want in c or -want in c:
        print(f'C[{want}]: {n}')
        want += 1
