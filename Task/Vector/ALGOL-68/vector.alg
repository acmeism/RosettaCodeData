# the standard mode COMPLEX is a two element vector #
MODE VECTOR = COMPLEX;
# the operations required for the task plus many others are provided as standard for COMPLEX and REAL items #
# the two components are fields called "re" and "im" #
# we can define a "pretty-print" operator: #
# returns a formatted representation of the vector #
OP TOSTRING = ( VECTOR a )STRING: "[" + TOSTRING re OF a + ", " + TOSTRING im OF a + "]";
# returns a formatted representation of the scaler #
OP TOSTRING = ( REAL a )STRING: fixed( a, 0, 4 );

# test the operations #
VECTOR a = 5 I 7, b = 2 I 3; # note the use of the I operator to construct a COMPLEX from two scalers #
print( ( "a+b : ", TOSTRING ( a + b  ), newline ) );
print( ( "a-b : ", TOSTRING ( a - b  ), newline ) );
print( ( "a*11: ", TOSTRING ( a * 11 ), newline ) );
print( ( "a/2 : ", TOSTRING ( a / 2  ), newline ) )
