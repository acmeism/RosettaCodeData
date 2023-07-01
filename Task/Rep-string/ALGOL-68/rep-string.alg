# procedure to find the longest rep-string in a given string               #
# the input string is not validated to contain only "0" and "1" characters #
PROC longest rep string = ( STRING input )STRING:
BEGIN

    STRING result           := "";

    # ensure the string we are working on has a lower-bound of 1           #
    STRING str               = input[ AT 1 ];

    # work backwards from half the input string looking for a rep-string   #
    FOR string length FROM UPB str OVER 2 BY -1 TO 1
    WHILE
        STRING left substring  = str[ 1 : string length ];
        # if the left substgring repeated a sufficient number of times     #
        # (truncated on the right) is equal to the original string, then   #
        # we have found the longest rep-string                             #
        STRING repeated string = ( left substring
                                 * ( ( UPB str OVER string length ) + 1 )
                                 )[ 1 : UPB str ];
        IF str = repeated string
        THEN
            # found a rep-string                                           #
            result := left substring;
            FALSE
        ELSE
            # not a rep-string, keep looking                               #
            TRUE
        FI
    DO
        SKIP
    OD;

    result
END; # longest rep string #


# test the longest rep string procedure                                    #
main:
(

    []STRING tests = ( "1001110011"
                     , "1110111011"
                     , "0010010010"
                     , "1010101010"
                     , "1111111111"
                     , "0100101101"
                     , "0100100"
                     , "101"
                     , "11"
                     , "00"
                     , "1"
                     );

    FOR test number FROM LWB tests TO UPB tests
    DO
        STRING rep string = longest rep string( tests[ test number ] );
        print( ( tests[ test number ]
               , ": "
               , IF rep string = ""
                 THEN "no rep string"
                 ELSE "longest rep string: """ + rep string + """"
                 FI
               , newline
               )
             )
    OD
)
