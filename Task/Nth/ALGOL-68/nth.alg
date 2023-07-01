# PROC to suffix a number with st, nd, rd or th as appropriate #
PROC nth = ( INT number )STRING:
BEGIN

    INT number mod 100 = number MOD 100;

# RESULT #
    whole( number, 0 )
  + IF number mod 100 >= 10 AND number mod 100 <= 20
    THEN
        # numbers in the range 10 .. 20 always have "th" #
        "th"
    ELSE
        # not in the range 10 .. 20, suffix is st, nd, rd or th #
        # depending on the final digit                          #
        CASE number MOD 10
        IN  # 1 # "st"
        ,   # 2 # "nd"
        ,   # 3 # "rd"
        OUT       "th"
        ESAC
    FI
END; # nth #

# PROC to test nth, displays nth for all numbers in the range from .. to  #
PROC test nth = ( INT from, INT to )VOID:
BEGIN
    INT test count := 0;
    FOR test value FROM from TO to
    DO
        STRING test result = nth( test value );
        print( ( "        "[ 1 : 8 - UPB test result ], nth( test value ) ) );
        test count +:= 1;
        IF test count MOD 8 = 0
        THEN
            print( ( newline ) )
        FI
    OD;
    print( ( newline ) )
END; # test nth #


main: (

    test nth(    0,   25 );
    test nth(  250,  265 );
    test nth( 1000, 1025 )

)
