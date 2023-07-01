f = (eqindex2Pass, eqindexMultiPass, eqindex1Pass)
d = ([-7, 1, 5, 2, -4, 3, 0],
     [2, 4, 6],
     [2, 9, 2],
     [1, -1, 1, -1, 1, -1, 1])

for data in d:
    print("d = %r" % data)
    for func in f:
        print("  %16s(d) -> %r" % (func.__name__, list(func(data))))
