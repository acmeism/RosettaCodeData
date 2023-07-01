class Mintab():
    "Tabulation, memoised minimised steps to 1"

    def __init__(self, divs=DIVS, subs=SUBS):
        self.divs, self.subs = divs, subs
        self.table = None   # Last tabulated table
        self.hows = None    # Last tabulated sample steps

    def _mintab(self, n):
        "Tabulation, memoised minimised steps to 1"
        divs, subs = self.divs, self.subs

        table = [n + 2] * (n + 1)   # sentinels
        table[1] = 0                # zero steps to 1 from 1
        how = [[''] for _ in range(n + 2)]  # What steps are taken
        how[1] = ['=']
        for t in range(1, n):
            thisplus1 = table[t] + 1
            for d in divs:
                dt = d * t
                if dt <= n and thisplus1 < table[dt]:
                    table[dt] = thisplus1
                    how[dt] = how[t] + [f'/{d}=>{t:2}']
            for s in subs:
                st = s + t
                if st <= n and thisplus1 < table[st]:
                    table[st] = thisplus1
                    how[st] = how[t] + [f'-{s}=>{t:2}']
        self.table = table
        self.hows = [h[::-1][:-1] for h in how]   # Order and trim
        return self.table, self.hows

    def __call__(self, n):
        "Tabulation"
        table, hows = self._mintab(n)
        return table[n], hows[n]


if __name__ == '__main__':
    for DIVS, SUBS in [({2, 3}, {1}), ({2, 3}, {2})]:
        print('\nMINIMUM STEPS TO 1: Tabulation algorithm')
        print('  Possible divisors:  ', DIVS)
        print('  Possible decrements:', SUBS)
        mintab = Mintab(DIVS, SUBS)
        mintab(10)
        table, hows = mintab.table, mintab.hows
        for n in range(1, 11):
            steps, how = table[n], hows[n]
            print(f'    mintab({n:2}) in {steps:2} by: ', ', '.join(how))

        for upto in [2000, 50_000]:
            mintab(upto)
            table = mintab.table
            print(f'\n    Those numbers up to {upto} that take the maximum, "minimal steps down to 1":')
            mx = max(table[1:])
            ans = [n for n, steps in enumerate(table) if steps == mx]
            print('      Taking', mx, f'steps is/are the {len(ans)} numbers:',
                  ', '.join(str(n) for n in ans))
