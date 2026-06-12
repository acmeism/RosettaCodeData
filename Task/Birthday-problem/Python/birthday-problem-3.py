# ought to use a memoize class for all this
# factorial
def fact(n, cache = {0: 1}):
    if not n in cache:
        cache[n] = n * fact(n - 1)
    return cache[n]

# permutations
def perm(n, k, cache = {}):
    if not (n, k) in cache:
        cache[(n, k)] = fact(n) // fact(n - k)
    return cache[(n, k)]

def choose(n, k, cache = {}):
    if not (n, k) in cache:
        cache[(n, k)] = perm(n, k) // fact(k)
    return cache[(n, k)]

# ways of distribute p people's birthdays into d days, with
# no more than m sharing any one day
def combos(d, p, m, cache = {}):
    if not p: return 1
    if not m: return 0
    if p <= m: return d ** p        # any combo would satisfy

    k = (d, p, m)
    if not k in cache:
        result = 0
        for x in range(p // m + 1):
            c = combos(d - x, p - x * m, m - 1)
            # ways to occupy x days with m people each
            if c: result += c * choose(d, x) * perm(p, x * m) // fact(m) ** x
        cache[k] = result

    return cache[k]

def find_half(m):
    n = 0
    while True:
        n += 1
        total = 365 ** n
        c = total - combos(365, n, m - 1)
        if c * 2 >= total:
            print("%d of %d people: %d/%d combos" % (n, m, c, total))
            return

for x in range(2, 6): find_half(x)
