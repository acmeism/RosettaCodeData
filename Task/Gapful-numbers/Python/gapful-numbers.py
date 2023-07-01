from itertools import islice, count
for start, n in [(100, 30), (1_000_000, 15), (1_000_000_000, 10)]:
    print(f"\nFirst {n} gapful numbers from {start:_}")
    print(list(islice(( x for x in count(start)
                        if (x % (int(str(x)[0]) * 10 + (x % 10)) == 0) )
                      , n)))
