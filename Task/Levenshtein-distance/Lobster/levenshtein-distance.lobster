def levenshtein(s: string, t: string) -> int:

    def makeNxM(n: int, m: int, v: int) -> [[int]]:
        let d:[[int]] = vector_reserve(typeof return, n)
        for(n) i:
            push(d, vector_reserve(typeof return, m))
            for(m) j:
                push(d[i], v)
        return d

    let ls = s.length
    let lt = t.length
    let d = makeNxM(ls + 1, lt + 1, -1)

    def dist (i: int, j: int) -> int:
        if d[i][j] >= 0:
            return d[i][j]
        var x = 0
        if i == ls:
            x = lt - j
        else: if j == lt:
            x = ls - i
        else: if s[i] == t[j]:
            x = dist(i + 1, j + 1)
        else:
            x = dist(i + 1, j + 1)
            x = min(x, dist(i, j + 1))
            x = min(x, dist(i + 1, j))
            x += 1
        d[i][j] = x
        return x

    return dist(0,0)

assert 3 == levenshtein("kitten", "sitting")
assert 8 == levenshtein("rosettacode", "raisethysword")
