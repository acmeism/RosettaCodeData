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
Output:
norm(q1) = 5.4772255750517
-q1 = -1.000000 -2.000000i -3.000000j -4.000000k
conj(q1) = 1.000000 -2.000000i -3.000000j -4.000000k
r+q1 = 13.000000 + 2.000000i + 3.000000j + 4.000000k
q1+r = 13.000000 + 2.000000i + 3.000000j + 4.000000k
r*q1 = 12.000000 + 24.000000i + 36.000000j + 48.000000k
q1*r = 12.000000 + 24.000000i + 36.000000j + 48.000000k
q1*q2 = -60.000000 + 12.000000i + 30.000000j + 24.000000k
q2*q1 = -60.000000 + 20.000000i + 14.000000j + 32.000000k
