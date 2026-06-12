def KlarnerRado(N):
    K = [1]
    for i in range(N):
        j = K[i]
        firstadd, secondadd = 2 * j + 1, 3 * j + 1
        if firstadd < K[-1]:
            for pos in range(len(K)-1, 1, -1):
                if K[pos] < firstadd < K[pos + 1]:
                    K.insert(pos + 1, firstadd)
                    break
        elif firstadd > K[-1]:
            K.append(firstadd)
        if secondadd < K[-1]:
            for pos in range(len(K)-1, 1, -1):
                if K[pos] < secondadd < K[pos + 1]:
                    K.insert(pos + 1, secondadd)
                    break
        elif secondadd > K[-1]:
            K.append(secondadd)

    return K

kr1m = KlarnerRado(100_000)

print('First 100 Klarner-Rado sequence numbers:')
for idx, v in enumerate(kr1m[:100]):
    print(f'{v: 4}', end='\n' if (idx + 1) % 20 == 0 else '')
for n in [1000, 10_000, 100_000]:
    print(f'The {n :,}th Klarner-Rado number is {kr1m[n-1] :,}')
