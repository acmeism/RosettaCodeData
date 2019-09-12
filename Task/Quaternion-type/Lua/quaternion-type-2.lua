q1 = Quaternion.new( 1, 2, 3, 4 )
q2 = Quaternion.new( 5, 6, 7, 8 )
r  = 12

print( "norm(q1) = ", Quaternion.norm( q1 ) )
io.write( "-q1 = " ); Quaternion.print( -q1 )
io.write( "conj(q1) = " ); Quaternion.print( Quaternion.conj( q1 ) )
io.write( "r+q1 = " ); Quaternion.print( r+q1 )
io.write( "q1+r = " ); Quaternion.print( q1+r )
io.write( "r*q1 = " ); Quaternion.print( r*q1 )
io.write( "q1*r = " ); Quaternion.print( q1*r )
io.write( "q1*q2 = " ); Quaternion.print( q1*q2 )
io.write( "q2*q1 = " ); Quaternion.print( q2*q1 )
