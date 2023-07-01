((x,y,z) for x in xrange(1,n+1) for y in xrange(x,n+1) for z in xrange(y,n+1) if x**2 + y**2 == z**2)
