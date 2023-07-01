def in_order(l):
    return all( l[i] <= l[i+1] for i in xrange(0,len(l)-1))
