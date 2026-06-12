from math import comb

def bern_tri(n, k):
    return sum([comb(n, i) for i in range(k+1)])

for i in range(15):
    print([bern_tri(i, k) for k in range(i+1)])
