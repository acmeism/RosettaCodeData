def partitions(N):
    diffs,k,s = [],1,1
    while k * (3*k-1) < 2*N:
        diffs.extend([(2*k - 1, s), (k, s)])
	k,s = k+1,-s

    out = [1] + [0]*N
    for p in range(0, N+1):
        x = out[p]
	for (o,s) in diffs:
           p += o
           if p > N: break
           out[p] += x*s

    return out

p = partitions(12345)
for x in [23,123,1234,12345]: print x, p[x]
