from itertools import groupby
o = (w for w in map(str.strip, open("unixdict.txt")) if sorted(w)==list(w))
print list(next(groupby(sorted(o, key=len, reverse=True), key=len))[1])
