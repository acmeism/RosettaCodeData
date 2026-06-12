from itertools import product, compress

fact = lambda n: n and n*fact(n - 1) or 1
combo_count = lambda total, coins, perm:\
                    sum(perm and fact(len(x)) or 1
                        for x in (list(compress(coins, c))
                                  for c in product(*([(0, 1)]*len(coins))))
                        if sum(x) == total)

cases = [(6,  [1, 2, 3, 4, 5]),
         (6,  [1, 1, 2, 3, 3, 4, 5]),
         (40, [1, 2, 3, 4, 5, 5, 5, 5, 15, 15, 10, 10, 10, 10, 25, 100])]

for perm in [False, True]:
    print(f'Order matters: {perm}')
    for s, c in cases:
        print(f'{combo_count(s, c, perm):7d} ways for {s:2d} total from coins {c}')
    print()
