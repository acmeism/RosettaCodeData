def isqrt ( x ):
    q = 1
    while q <= x :
        q *= 4
    z,r = x,0
    while q > 1 :
        q  /= 4
        t,r = z-r-q,r/2
        if t >= 0 :
            z,r = t,r+q
    return r

print ' '.join( '%d'%isqrt( n ) for n in xrange( 66 ))
print '\n'.join( '{0:114,} = isqrt( 7^{1:3} )'.format( isqrt( 7**n ),n ) for n in range( 1,204,2 ))
