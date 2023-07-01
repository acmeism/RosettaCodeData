from functools import lru_cache


#%%

DIVS = {2, 3}
SUBS = {1}

class Minrec():
    "Recursive, memoised minimised steps to 1"

    def __init__(self, divs=DIVS, subs=SUBS):
        self.divs, self.subs = divs, subs

    @lru_cache(maxsize=None)
    def _minrec(self, n):
        "Recursive, memoised"
        if n == 1:
            return 0, ['=1']
        possibles = {}
        for d in self.divs:
            if n % d == 0:
                possibles[f'/{d}=>{n // d:2}'] = self._minrec(n // d)
        for s in self.subs:
            if n > s:
                possibles[f'-{s}=>{n - s:2}'] = self._minrec(n - s)
        thiskind, (count, otherkinds) = min(possibles.items(), key=lambda x: x[1])
        ret = 1 + count, [thiskind] + otherkinds
        return ret

    def __call__(self, n):
        "Recursive, memoised"
        ans = self._minrec(n)[1][:-1]
        return len(ans), ans


if __name__ == '__main__':
    for DIVS, SUBS in [({2, 3}, {1}), ({2, 3}, {2})]:
        minrec = Minrec(DIVS, SUBS)
        print('\nMINIMUM STEPS TO 1: Recursive algorithm')
        print('  Possible divisors:  ', DIVS)
        print('  Possible decrements:', SUBS)
        for n in range(1, 11):
            steps, how = minrec(n)
            print(f'    minrec({n:2}) in {steps:2} by: ', ', '.join(how))

        upto = 2000
        print(f'\n    Those numbers up to {upto} that take the maximum, "minimal steps down to 1":')
        stepn = sorted((minrec(n)[0], n) for n in range(upto, 0, -1))
        mx = stepn[-1][0]
        ans = [x[1] for x in stepn if x[0] == mx]
        print('      Taking', mx, f'steps is/are the {len(ans)} numbers:',
              ', '.join(str(n) for n in sorted(ans)))
        #print(minrec._minrec.cache_info())
        print()
