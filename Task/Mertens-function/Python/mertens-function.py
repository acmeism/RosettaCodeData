def mertens(count):
    """Generate Mertens numbers"""
    m = [None, 1]
    for n in range(2, count+1):
        m.append(1)
        for k in range(2, n+1):
            m[n] -= m[n//k]
    return m


ms = mertens(1000)

print("The first 99 Mertens numbers are:")
print("  ", end=' ')
col = 1
for n in ms[1:100]:
    print("{:2d}".format(n), end=' ')
    col += 1
    if col == 10:
        print()
        col = 0

zeroes = sum(x==0 for x in ms)
crosses = sum(a!=0 and b==0 for a,b in zip(ms, ms[1:]))
print("M(N) equals zero {} times.".format(zeroes))
print("M(N) crosses zero {} times.".format(crosses))
