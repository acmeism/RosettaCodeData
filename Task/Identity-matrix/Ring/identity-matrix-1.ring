size = 5
im = newlist(size, size)
identityMatrix(size, im)
for r = 1 to size
    for c = 1 to size
        see im[r][c]
    next
    see nl
next

func identityMatrix s, m
     m = newlist(s, s)
     for i = 1 to s
         m[i][i] = 1
     next
     return m

func newlist x, y
     if isstring(x) x=0+x ok
     if isstring(y) y=0+y ok
     alist = list(x)
     for t in alist
         t = list(y)
     next
     return alist
