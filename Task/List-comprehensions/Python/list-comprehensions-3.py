[(x, y, z) for (x, y, z) in itertools.product(xrange(1,n+1),repeat=3) if x**2 + y**2 == z**2 and x <= y <= z]
