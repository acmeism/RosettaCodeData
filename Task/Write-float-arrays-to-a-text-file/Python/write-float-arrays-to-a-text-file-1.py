import itertools
def writedat(filename, x, y, xprecision=3, yprecision=5):
    with open(filename,'w') as f:
        for a, b in itertools.izip(x, y):
            print >> f, "%.*g\t%.*g" % (xprecision, a, yprecision, b)
