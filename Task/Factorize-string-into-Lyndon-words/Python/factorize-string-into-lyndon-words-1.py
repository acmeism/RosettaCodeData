def chen_fox_lyndon_factorization(s):
    n = len(s)
    i = 0
    factorization = []
    while i < n:
        j, k = i + 1, i
        while j < n and s[k] <= s[j]:
            if s[k] < s[j]:
                k = i
            else:
                k += 1
            j += 1
        while i <= k:
            factorization.append(s[i:i + j - k])
            i += j - k
    assert ''.join(factorization) == s
    return factorization
