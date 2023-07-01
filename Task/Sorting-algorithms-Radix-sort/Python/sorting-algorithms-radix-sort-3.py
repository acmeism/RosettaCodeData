#python3.7 <
def flatten(l):
    return [y for x in l for y in x]

def radix(l, p=None, s=None):
    if s == None:
        s = len(str(max(l)))
    if p == None:
        p = s

    i = s - p

    if i >= s:
        return l

    bins = [[] for _ in range(10)]

    for e in l:
        bins[int(str(e).zfill(s)[i])] += [e]

    return flatten([radix(b, p-1, s) for b in bins])
