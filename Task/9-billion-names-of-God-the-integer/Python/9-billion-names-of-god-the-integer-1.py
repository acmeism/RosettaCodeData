cache = [[1]]
def cumu(n):
    for l in range(len(cache), n+1):
        r = [0]
        for x in range(1, l+1):
            r.append(r[-1] + cache[l-x][min(x, l-x)])
        cache.append(r)
    return cache[n]

def row(n):
    r = cumu(n)
    return [r[i+1] - r[i] for i in range(n)]

print "rows:"
for x in range(1, 11): print "%2d:"%x, row(x)


print "\nsums:"
for x in [23, 123, 1234, 12345]: print x, cumu(x)[-1]
