class Setr():
    def __init__(self, lo, hi, includelo=True, includehi=False):
        self.eqn = "(%i<%sX<%s%i)" % (lo,
                                      '=' if includelo else '',
                                      '=' if includehi else '',
                                      hi)

    def __contains__(self, X):
        return eval(self.eqn, locals())

    # union
    def __or__(self, b):
        ans = Setr(0,0)
        ans.eqn = "(%sor%s)" % (self.eqn, b.eqn)
        return ans

    # intersection
    def __and__(self, b):
        ans = Setr(0,0)
        ans.eqn = "(%sand%s)" % (self.eqn, b.eqn)
        return ans

    # difference
    def __sub__(self, b):
        ans = Setr(0,0)
        ans.eqn = "(%sand not%s)" % (self.eqn, b.eqn)
        return ans

    def __repr__(self):
        return "Setr%s" % self.eqn


sets = [
    Setr(0,1, 0,1) | Setr(0,2, 1,0),
    Setr(0,2, 1,0) & Setr(1,2, 0,1),
    Setr(0,3, 1,0) - Setr(0,1, 0,0),
    Setr(0,3, 1,0) - Setr(0,1, 1,1),
]
settexts = '(0, 1] ∪ [0, 2);[0, 2) ∩ (1, 2];[0, 3) − (0, 1);[0, 3) − [0, 1]'.split(';')

for s,t in zip(sets, settexts):
    print("Set %s %s. %s" % (t,
                             ', '.join("%scludes %i"
                                     % ('in' if v in s else 'ex', v)
                                     for v in range(3)),
                             s.eqn))
