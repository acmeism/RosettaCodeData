def ld(a, b, mx=-1):	
    def result(d): return d if mx < 0 else False if d > mx else True

    if a == b: return result(0)
    la, lb = len(a), len(b)
    if mx >= 0 and abs(la - lb) > mx: return result(mx+1)
    if la == 0: return result(lb)
    if lb == 0: return result(la)
    if lb > la: a, b, la, lb = b, a, lb, la

    cost = array('i', range(lb + 1))
    for i in range(1, la + 1):
        cost[0] = i; ls = i-1; mn = ls
        for j in range(1, lb + 1):
            ls, act = cost[j], ls + int(a[i-1] != b[j-1])
            cost[j] = min(ls+1, cost[j-1]+1, act)
            if (ls < mn): mn = ls
        if mx >= 0 and mn > mx: return result(mx+1)
    if mx >= 0 and cost[lb] > mx: return result(mx+1)
    return result(cost[lb])

print(
    ld('kitten','kitten'), # 0
    ld('kitten','sitten'), # 1
    ld('kitten','sittes'), # 2
    ld('kitten','sityteng'), # 3
    ld('kitten','sittYing'), # 4
    ld('rosettacode','raisethysword'), # 8
    ld('kitten','kittenaaaaaaaaaaaaaaaaa'), # 17
    ld('kittenaaaaaaaaaaaaaaaaa','kitten') # 17
)

print(
    ld('kitten','kitten',3), # True
    ld('kitten','sitten',3), # True
    ld('kitten','sittes',3), # True
    ld('kitten','sityteng',3), # True
    ld('kitten','sittYing',3), # False
    ld('rosettacode','raisethysword',3), # False
    ld('kitten','kittenaaaaaaaaaaaaaaaaa',3), # False
    ld('kittenaaaaaaaaaaaaaaaaa','kitten',3) # False
)
