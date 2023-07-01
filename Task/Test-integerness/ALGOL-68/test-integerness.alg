# set the required precision of LONG LONG values using    #
# "PR precision n PR" if required                         #
PR precision 24 PR

# returns TRUE if v has an integer value, FALSE otherwise #
OP ISINT = ( LONG LONG COMPL v )BOOL:
   IF im OF v /= 0 THEN
       # v has an imaginary part #
       FALSE
   ELSE
       # v has a real part only #
       ENTIER re OF v = v
   FI; # ISINT #

# test ISINT #

PROC test is int = ( LONG LONG COMPLEX v )VOID:
     print( ( re OF v, "_", im OF v, IF ISINT v THEN " is " ELSE " is not " FI, "integral", newline ) );


test is int( 1 );
test is int( 1.00000001 );
test is int( 4 I 3 );
test is int( 4.0 I 0 );
test is int( 123456789012345678901234 )
