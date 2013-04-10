doors = [False] * 100
for i in xrange(100):
    for j in xrange(i, 100, i+1):
        doors[j] = not doors[j]
    print "Door %d:" % (i+1), 'open' if doors[i] else 'close'
