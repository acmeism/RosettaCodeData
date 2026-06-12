from itertools import chain

LIST = ["1a3c52debeffd", "2b6178c97a938stf", "3ycxdb1fgxa2yz"]

print(
    sorted(
        ch
        for ch in set(chain.from_iterable(LIST))
        if all(w.count(ch) == 1 for w in LIST)
    )
)
