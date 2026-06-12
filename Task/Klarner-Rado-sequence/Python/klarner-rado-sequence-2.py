from numpy import ndarray

def KlarnerRado(N):
    kr = ndarray(100 * N, dtype=bool)
    kr[1] = True
    for i in range(30 * N):
        if kr[i]:
            kr[2 * i + 1] = True
            kr[3 * i + 1] = True

    return [i for i in range(100 * N) if kr[i]]

kr1m = KlarnerRado(1_000_000)

print('First 100 Klarner-Rado sequence numbers:')
for idx, v in enumerate(kr1m[:100]):
    print(f'{v: 4}', end='\n' if (idx + 1) % 20 == 0 else '')
for n in [1000, 10_000, 100_000, 1_000_000]:
    print(f'The {n :,}th Klarner-Rado number is {kr1m[n-1] :,}')
