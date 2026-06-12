def gospers_hack(x):
    c = x & -x
    r = x + c
    return (((r ^ x) >> 2) // c) | r

for start in [1, 3, 7, 15]:
    x = start
    results = []
    for _ in range(10):
        x = gospers_hack(x)
        results.append(str(x))
    print(f"{start}: {' '.join(results)}")
