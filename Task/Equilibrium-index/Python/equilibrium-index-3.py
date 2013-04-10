def eqindexMultiPass(s):
    return [i for i in xrange(len(s)) if sum(s[:i]) == sum(s[i+1:])]

print eqindexMultiPass([-7, 1, 5, 2, -4, 3, 0])
