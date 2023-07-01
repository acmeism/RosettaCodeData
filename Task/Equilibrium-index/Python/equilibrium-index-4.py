from collections import defaultdict

def eqindex1Pass(data):
    "One pass"
    l, h = 0, defaultdict(list)
    for i, c in enumerate(data):
        l += c
        h[l * 2 - c].append(i)
    return h[l]
