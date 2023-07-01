def foursquares(lo,hi,unique,show):

    def acd_iter():
        """
        Iterates through all the possible valid values of
        a, c, and d.

        a = c + d
        """
        for c in range(lo,hi+1):
            for d in range(lo,hi+1):
                if (not unique) or (c <> d):
                    a = c + d
                    if a >= lo and a <= hi:
                        if (not unique) or (c <> 0 and d <> 0):
                            yield (a,c,d)

    def ge_iter():
        """
        Iterates through all the possible valid values of
        g and e.

        g = d + e
        """
        for e in range(lo,hi+1):
            if (not unique) or (e not in (a,c,d)):
                g = d + e
                if g >= lo and g <= hi:
                    if (not unique) or (g not in (a,c,d,e)):
                        yield (g,e)

    def bf_iter():
        """
        Iterates through all the possible valid values of
        b and f.

        b = e + f - c
        """
        for f in range(lo,hi+1):
            if (not unique) or (f not in (a,c,d,g,e)):
                b = e + f - c
                if b >= lo and b <= hi:
                    if (not unique) or (b not in (a,c,d,g,e,f)):
                        yield (b,f)

    solutions = 0
    acd_itr = acd_iter()
    for acd in acd_itr:
        a,c,d = acd
        ge_itr = ge_iter()
        for ge in ge_itr:
            g,e = ge
            bf_itr = bf_iter()
            for bf in bf_itr:
                b,f = bf
                solutions += 1
                if show:
                    print str((a,b,c,d,e,f,g))[1:-1]
    if unique:
        uorn = "unique"
    else:
        uorn = "non-unique"

    print str(solutions)+" "+uorn+" solutions in "+str(lo)+" to "+str(hi)
    print
