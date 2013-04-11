def grouper(lst):
    src = iter(lst)
    acc = [ next(src) ]
    for i in src:
        if i == acc[-1] + 1: acc.append(i)
        else:
            yield acc
            acc = [i]
    yield acc
    raise StopIteration()

def rangegrouper(lst):
    for g in grouper(lst):
        if len(g) == 2:
            # satisfy rule that only runs longer than 2 are grouped
            a,b = g
            yield [a]
            yield [b]
        else: yield g
    raise StopIteration()

input= [0,  1,  2,  4,  6,  7,  8, 11, 12, 14,15, 16, 17, 18, 19, 20, 21, 22, 23, 24,   25, 27, 28, 29, 30, 31, 32, 33, 35, 36,37, 38, 39]
print list(rangegrouper(input)) # print groups
as_strings= ['%s%s%s' % ((g[0],'-',g[-1]) if len(g) > 1 else (g[0],'','')) for g in rangegrouper(input)]
print as_strings
print ', '.join(as_strings)
