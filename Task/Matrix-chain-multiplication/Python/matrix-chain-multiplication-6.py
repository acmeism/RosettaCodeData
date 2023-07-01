import time

u = [[1, 5, 25, 30, 100, 70, 2, 1, 100, 250, 1, 1000, 2],
     [1000, 1, 500, 12, 1, 700, 2500, 3, 2, 5, 14, 10]]

for a in u:
    print(a)
    print()
    print("function     time       cost   parens  ")
    print("-" * 90)
    for f in [optim1, optim2, optim3]:
        t1 = time.clock()
        s, u = f(a)
        t2 = time.clock()
        print("%s %10.3f %10d   %s" % (f.__name__, 1000 * (t2 - t1), s, u))
    print()
