# maps a real s in the range [ a1, a2 ] to the range [ b1, b2 ]           #
# there are no checks that s is in the range or that the ranges are valid #
PROC map range = ( REAL s, a1, a2, b1, b2 )REAL:
    b1 + ( ( s - a1 ) * ( b2 - b1 ) ) / ( a2 - a1 );

# test the mapping #
FOR i FROM 0 TO 10 DO
    print( ( whole( i, -2 ), " maps to ", fixed( map range( i, 0, 10, -1, 0 ), -8, 2 ), newline ) )
OD
