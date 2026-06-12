def E(k, n):
    s = [[1] if i < k else [0] for i in range(n)]

    d = n - k
    n = max(k, d)
    k = min(k, d)
    z = d

    while z > 0 or k > 1:
        for i in range(k):
            s[i].extend(s[len(s) - 1 - i])
        s = s[:-k]
        z = z - k
        d = n - k
        n = max(k, d)
        k = min(k, d)

    return [item for sublist in s for item in sublist]

print(''.join(map(str, E(5, 13))))
# 1001010010100
