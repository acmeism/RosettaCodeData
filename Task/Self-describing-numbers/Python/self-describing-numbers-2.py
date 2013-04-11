def impl(d, c, m):
    if m < 0: return
    if d == c[:len(d)]: print d
    for i in range(c[len(d)],m+1):
        dd = d+[i]
        if i<len(dd) and c[i]==dd[i]: continue
        impl(dd,c[:i]+[c[i]+1]+c[i+1:],m-i)

def self(n): impl([], [0]*(n+1), n)

self(10)
