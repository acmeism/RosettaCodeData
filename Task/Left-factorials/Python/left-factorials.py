from itertools import islice

def lfact():
    yield 0
    fact, summ, n = 1, 0, 1
    while 1:
        fact, summ, n = fact*n, summ + fact, n + 1
        yield summ

print('first 11:\n  %r' % [lf for i, lf in zip(range(11), lfact())])
print('20 through 110 (inclusive) by tens:')
for lf in islice(lfact(), 20, 111, 10):
    print(lf)
print('Digits in 1,000 through 10,000 (inclusive) by thousands:\n  %r'
      % [len(str(lf)) for lf in islice(lfact(), 1000, 10001, 1000)] )
