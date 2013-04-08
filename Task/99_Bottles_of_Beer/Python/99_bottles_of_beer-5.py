a = lambda n: "%u bottle%s of beer on the wall\n" % (n, "s"[n==1:])
print "\n".join(a(x)+a(x)[:-13]+"\nTake one down, pass it around\n"+a(x-1) for x in xrange(99, 0, -1))
