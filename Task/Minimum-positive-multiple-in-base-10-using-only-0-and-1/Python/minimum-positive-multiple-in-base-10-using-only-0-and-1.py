def getA004290(n):
    if n < 2:
        return 1
    arr = [[0 for _ in range(n)] for _ in range(n)]
    arr[0][0] = 1
    arr[0][1] = 1
    m = 0
    while True:
        m += 1
        if arr[m - 1][-10 ** m % n] == 1:
            break
        arr[m][0] = 1
        for k in range(1, n):
            arr[m][k] = max([arr[m - 1][k], arr[m - 1][k - 10 ** m % n]])
    r = 10 ** m
    k = -r % n
    for j in range((m - 1), 0, -1):
        if arr[j - 1][k] == 0:
            r = r + 10 ** j
            k = (k - 10 ** j) % n
    if k == 1:
        r += 1
    return r

for n in [i for i in range(1, 11)] + \
          [i for i in range(95, 106)] + \
          [297, 576, 594, 891, 909, 999, 1998, 2079, 2251, 2277, 2439, 2997, 4878]:
    result = getA004290(n)
    print(f"A004290({n}) = {result} = {n} * {result // n})")
