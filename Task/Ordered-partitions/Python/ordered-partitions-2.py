from itertools import combinations as comb

def partitions(*args):
    def minus(s1, s2): return [x for x in s1 if x not in s2]
    def p(s, *args):
        if not args: return [[]]
        return [[c] + r for c in comb(s, args[0]) for r in p(minus(s, c), *args[1:])]
    return p(range(1, sum(args) + 1), *args)

print partitions(2, 0, 2)
