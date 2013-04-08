a, b, c, s = " bottles of beer", " on the wall\n", "Take one down, pass it around\n", str
print "\n".join(s(x)+a+b+s(x)+a+"\n"+c+s(x-1)+a+b for x in xrange(99, 0, -1))
