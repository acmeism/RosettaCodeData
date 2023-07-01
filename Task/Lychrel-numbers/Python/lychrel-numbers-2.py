from __future__ import print_function

def rev(n): return int(str(n)[::-1])

def lychel(n, cache = {}):
    if n in cache: return cache[n]

    n0, r = n, rev(n)
    res, seen = (True, n), []
    for i in range(1000):
        n += r
        r = rev(n)
        if n == r:
            res = (False, 0)
            break
        if n in cache:
            res = cache[n]
            break
        seen.append(n)

    for x in seen: cache[x] = res
    return res

seeds, related, palin = [], [], []

for i in range(1, 1000000):
    tf, s = lychel(i)
    if not tf: continue
    (seeds if i == s else related).append(i)
    if i == rev(i): palin.append(i)

print("%d Lychel seeds:"%len(seeds), seeds)
print("%d Lychel related" % len(related))
print("%d Lychel palindromes:" % len(palin), palin)
