from fractions import Fraction
from math import ceil

class Fr(Fraction):
    def __repr__(self):
        return '%s/%s' % (self.numerator, self.denominator)

def ef(fr):
    ans = []
    if fr >= 1:
        if fr.denominator == 1:
            return [[int(fr)], Fr(0, 1)]
        intfr = int(fr)
        ans, fr = [[intfr]], fr - intfr
    x, y = fr.numerator, fr.denominator
    while x != 1:
        ans.append(Fr(1, ceil(1/fr)))
        fr = Fr(-y % x, y* ceil(1/fr))
        x, y = fr.numerator, fr.denominator
    ans.append(fr)
    return ans

if __name__ == '__main__':
    for fr in [Fr(43, 48), Fr(5, 121), Fr(2014, 59)]:
        print('%r ─► %s' % (fr, ' '.join(str(x) for x in ef(fr))))
    lenmax = denommax = (0, None)
    for fr in set(Fr(a, b) for a in range(1,100) for b in range(1, 100)):
        e = ef(fr)
        #assert sum((f[0] if type(f) is list else f) for f in e) == fr, 'Whoops!'
        elen, edenom = len(e), e[-1].denominator
        if elen > lenmax[0]:
            lenmax = (elen, fr, e)
        if edenom > denommax[0]:
            denommax = (edenom, fr, e)
    print('Term max is %r with %i terms' % (lenmax[1], lenmax[0]))
    dstr = str(denommax[0])
    print('Denominator max is %r with %i digits %s...%s' %
          (denommax[1], len(dstr), dstr[:5], dstr[-5:]))
