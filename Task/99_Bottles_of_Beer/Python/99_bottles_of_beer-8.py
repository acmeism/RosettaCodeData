for n in xrange(99, 0, -1):
    ##  The formatting performs a conditional check on the variable.
    ##  If it formats the first open for False, and the second for True
    print n, 'bottle%s of beer on the the wall.' % ('s', '')[n == 1]
    print n, 'bottle%s of beer.' % ('s', '')[n == 1]
    print 'Take one down, pass it around.'
    print n - 1, 'bottle%s of beer on the wall.\n' % ('s', '')[n - 1 == 1]
