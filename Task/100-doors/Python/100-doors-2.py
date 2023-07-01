for i in xrange(1, 101):
    root = i ** 0.5
    print "Door %d:" % i, 'open' if root == int(root) else 'close'
