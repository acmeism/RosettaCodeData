LIST = ["1a3c52debeffd", "2b6178c97a938stf", "3ycxdb1fgxa2yz"]

print(sorted([ch for ch in set([c for c in ''.join(LIST)]) if all(w.count(ch) == 1 for w in LIST)]))
