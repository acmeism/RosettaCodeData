cubes, crev = [x**3 for x in range(1,1200)], {}
# for cube root lookup
for x,x3 in enumerate(cubes): crev[x3] = x + 1

sums = sorted(x+y for x in cubes for y in cubes if y < x)

idx = 0
for i in range(1, len(sums)-1):
    if sums[i-1] != sums[i] and sums[i] == sums[i+1]:
        idx += 1
        if idx > 25 and idx < 2000 or idx > 2006: continue

        n,p = sums[i],[]
        for x in cubes:
            if n-x < x: break
            if n-x in crev:
                p.append((crev[x], crev[n-x]))
        print "%4d: %10d"%(idx,n),
        for x in p: print " = %4d^3 + %4d^3"%x,
        print
