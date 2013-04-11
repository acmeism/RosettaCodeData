def powersetlist(s):
    r = [[]]
    for e in s:
        print "r: %-55r e: %r" % (r,e)
        r += [x+[e] for x in r]
    return r

s= [0,1,2,3]
print "\npowersetlist(%r) =\n  %r" % (s, powersetlist(s))
