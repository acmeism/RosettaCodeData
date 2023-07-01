from itertools import product

xx = '-5 +5'.split()
pp = '2 3'.split()
texts = '-x**p -(x)**p (-x)**p -(x**p)'.split()

print('Integer variable exponentiation')
for x, p in product(xx, pp):
    print(f'  x,p = {x:2},{p}; ', end=' ')
    x, p = int(x), int(p)
    print('; '.join(f"{t} =={eval(t):4}" for t in texts))

print('\nBonus integer literal exponentiation')
X, P = 'xp'
xx.insert(0, ' 5')
texts.insert(0, 'x**p')
for x, p in product(xx, pp):
    texts2 = [t.replace(X, x).replace(P, p) for t in texts]
    print(' ', '; '.join(f"{t2} =={eval(t2):4}" for t2 in texts2))
