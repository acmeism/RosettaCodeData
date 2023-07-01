def ffr(n):
    if n < 1 or type(n) != int: raise ValueError("n must be an int >= 1")
    try:
        return ffr.r[n]
    except IndexError:
        r, s = ffr.r, ffs.s
        ffr_n_1 = ffr(n-1)
        lastr = r[-1]
        # extend s up to, and one past, last r
        s += list(range(s[-1] + 1, lastr))
        if s[-1] < lastr: s += [lastr + 1]
        # access s[n-1] temporarily extending s if necessary
        len_s = len(s)
        ffs_n_1 = s[n-1] if len_s > n else (n - len_s) + s[-1]
        ans = ffr_n_1 + ffs_n_1
        r.append(ans)
        return ans
ffr.r = [None, 1]

def ffs(n):
    if n < 1 or type(n) != int: raise ValueError("n must be an int >= 1")
    try:
        return ffs.s[n]
    except IndexError:
        r, s = ffr.r, ffs.s
        for i in range(len(r), n+2):
            ffr(i)
            if len(s) > n:
                return s[n]
        raise Exception("Whoops!")
ffs.s = [None, 2]

if __name__ == '__main__':
    first10 = [ffr(i) for i in range(1,11)]
    assert first10 == [1, 3, 7, 12, 18, 26, 35, 45, 56, 69], "ffr() value error(s)"
    print("ffr(n) for n = [1..10] is", first10)
    #
    bin = [None] + [0]*1000
    for i in range(40, 0, -1):
        bin[ffr(i)] += 1
    for i in range(960, 0, -1):
        bin[ffs(i)] += 1
    if all(b == 1 for b in bin[1:1000]):
        print("All Integers 1..1000 found OK")
    else:
        print("All Integers 1..1000 NOT found only once: ERROR")
