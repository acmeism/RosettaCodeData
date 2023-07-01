from itertools import combinations

def partitions(*args):
    def p(s, *args):
        if not args: return [[]]
        res = []
        for c in combinations(s, args[0]):
            s0 = [x for x in s if x not in c]
            for r in p(s0, *args[1:]):
                res.append([c] + r)
        return res
    s = range(sum(args))
    return p(s, *args)

print partitions(2, 0, 2)
