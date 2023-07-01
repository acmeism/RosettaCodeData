def writedat(filename, x, y, xprecision=3, yprecision=5):
    with open(filename,'w') as f:
        for a, b in zip(x, y):
            print("%.*g\t%.*g" % (xprecision, a, yprecision, b), file=f)
            #or, using the new-style formatting:
            #print("{1:.{0}g}\t{3:.{2}g}".format(xprecision, a, yprecision, b), file=f)
