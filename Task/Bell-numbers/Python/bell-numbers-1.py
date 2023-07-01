def bellTriangle(n):
    tri = [None] * n
    for i in xrange(n):
        tri[i] = [0] * i
    tri[1][0] = 1
    for i in xrange(2, n):
        tri[i][0] = tri[i - 1][i - 2]
        for j in xrange(1, i):
            tri[i][j] = tri[i][j - 1] + tri[i - 1][j - 1]
    return tri

def main():
    bt = bellTriangle(51)
    print "First fifteen and fiftieth Bell numbers:"
    for i in xrange(1, 16):
        print "%2d: %d" % (i, bt[i][0])
    print "50:", bt[50][0]
    print
    print "The first ten rows of Bell's triangle:"
    for i in xrange(1, 11):
        print bt[i]

main()
