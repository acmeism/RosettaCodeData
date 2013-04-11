def rangeextract(lst):
    lenlst = len(lst)
    i, ranges = 0, []
    while i< lenlst:
        low = lst[i]
        while i <lenlst-1 and lst[i]+1 == lst[i+1]: i +=1
        hi = lst[i]
        ranges.append(
            '%i-%i'  % (low, hi) if hi - low >= 2 else
            ('%i,%i' % (low, hi) if hi - low == 1 else
             '%i' % low) )
        i += 1
    return ','.join(ranges)

lst = [ 0,  1,  2,  4,  6,  7,  8, 11, 12, 14,
       15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
       25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
       37, 38, 39]
print(rangeextract(lst))
