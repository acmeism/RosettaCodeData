def comb(m, lst):
    if m == 0:
        return [[]]
    else:
        return [[x] + suffix for i, x in enumerate(lst)
                for suffix in comb(m - 1, lst[i + 1:])]
