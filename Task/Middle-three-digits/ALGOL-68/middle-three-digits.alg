# we define a UNION MODE so that our middle 3 digits PROC can #
# return either an integer on success or a error message if   #
# the middle 3 digits couldn't be extracted                   #
MODE EINT = UNION( INT # success value #, STRING # error message # );
# PROC to return the middle 3 digits of an integer.           #
# if this is not possible, an error message is returned       #
# instead                                                     #
PROC middle 3 digits = ( INT number ) EINT:
BEGIN
    # convert the absolute value of the number to a string with the  #
    # minumum possible number characters                             #
    STRING digits     = whole( ABS number, 0 );
    INT    len        = UPB digits;
    IF   len < 3
    THEN
        # number has less than 3 digits #
        # return an error message       #
        "number must have at least three digits"
    ELIF ( len MOD 2 ) = 0
    THEN
        # the number has an even number of digits #
        # return an error message                 #
        "number must have an odd number of digits"
    ELSE
        # the number is suitable for extraction of the middle 3 digits #
        INT first digit pos = 1 + ( ( len - 3 ) OVER 2 );
        # the result is the integer value of the three digits          #
        ( ( ( ABS digits[ first digit pos     ] - ABS "0" ) * 100 )
        + ( ( ABS digits[ first digit pos + 1 ] - ABS "0" ) *  10 )
        + ( ( ABS digits[ first digit pos + 2 ] - ABS "0" )       )
        )
    FI
END; # middle 3 digits #

main: (
    # test the middle 3 digits PROC #
    []INT test values = (    123,  12345, 1234567, 987654321
                        ,  10001, -10001,    -123,      -100
                        ,    100, -12345
                          # the following values should fail #
                        , 1, 2, -1, -10, 2002, -2002, 0
                        );
    FOR test number FROM LWB test values TO UPB test values
    DO
        CASE middle 3 digits( test values[ test number ] )
        IN
        ( INT     success value ):    # got the middle 3 digits #
            printf( ( $ 11z-d, " : ", 3d $
                    , test values[ test number ]
                    , success value
                    )
                  )
            ,
        ( STRING  error message  ):    # got an error message   #
            printf( ( $ 11z-d, " : ", n( UPB error message )a $
                    , test values[ test number ]
                    , error message
                    )
                  )
        ESAC;
        print( ( newline ) )
    OD
)
