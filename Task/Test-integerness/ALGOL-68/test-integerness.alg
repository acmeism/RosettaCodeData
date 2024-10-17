# set the required precision of LONG LONG values using    #
# "PR precision n PR" if required                         #
# PR precision 24 PR # # not requied for ALGOL 68 Genie   #
                       # the default precision is > 24    #
                       # and can't be reduced to 24       #

# returns TRUE if v has an integer value, FALSE otherwise #
OP ISINT = ( LONG LONG COMPL v )BOOL:
   IF im OF v /= 0 THEN
       # v has an imaginarh part #
       FALSE
   ELSE
       # v has a real part only #
       ENTIER re OF v = v
   FI; # ISINT #

# test ISINT #

PROC test is int = ( LONG LONG COMPLEX v )VOID:
     BEGIN
        print( ( float( re OF v, -36, 28, 4 ), "_", float( im OF v, -36, 28, 4 ) ) );
        print( ( IF ISINT v THEN " is " ELSE " is not " FI, "integral", newline ) )
     END # test is int # ;


test is int( 1 );
test is int( 1.00000001 );
test is int( 4 I 3 );
test is int( 4.0 I 0 );
test is int( 123456789012345678901234 )
