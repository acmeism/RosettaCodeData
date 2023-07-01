from math import log2
from collections import Counter

def entropy(s):
    p, lns = Counter(s), float(len(s))
    return log2(lns) - sum(count * log2(count) for count in p.values()) / lns

print(entropy("1223334444"))
