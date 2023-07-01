def comb(m, s):
    if m == 1: return [[x] for x in s]
    if m == len(s): return [s]
    return [s[:1] + a for a in comb(m-1, s[1:])] + comb(m, s[1:])
