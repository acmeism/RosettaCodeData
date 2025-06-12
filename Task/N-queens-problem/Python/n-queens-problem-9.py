def queens(n):
    def q(pl, r):
        def place(c):
            return r+c not in pl[1] and r-c not in pl[2]
        return ((pl[0]+[c], pl[1]|{r+c}, pl[2]|{r-c}, pl[3]-{c})
            for c in pl[3] if place(c))
    def pipeline(pl, i):
        for ipl in q(pl, i):
            if i+1 < n:
                yield from pipeline(ipl, i+1)
            else:
                yield ipl[0]
    def toletter(x):
        return 'abcdefghijklmnopqrstuvwxyz'[x]
    def fund_solut(fl):
        def inversed(xl):
            return (xl.index(i) for i in range(0, n))
        def variants(xl):
            rl = [xl]
            rl += [[*inversed(x)] for x in rl]
            rl += [[*reversed(x)] for x in rl]
            rl += [[n-1-i for i in x] for x in rl]
            return (''.join(toletter(i) for i in x) for x in rl)
        rs = set()
        for i in fl:
            ks = {*variants(i)}
            if rs.isdisjoint(ks):
                rs |= ks
                yield i
    for i in fund_solut(
        pipeline(([], set(), set(), {*range(0, n)}), 0)):
        rl = sorted(toletter(v)+str(k+1) for k, v in enumerate(i))
        print(rl)
queens(8)
