# returns c decoded as a hex digit #
PROC hex value = ( CHAR c )INT: IF   c >= "0" AND c <= "9" THEN        ABS c - ABS "0"
                                ELIF c >= "A" AND c <= "F" THEN 10 + ( ABS c - ABS "A" )
                                ELSE                            10 + ( ABS c - ABS "a" )
                                FI;

# returns the URL encoded string decoded - minimal error handling #
PROC url decode = ( STRING encoded )STRING:
     BEGIN
         [ LWB encoded : UPB encoded ]CHAR result;
         INT result pos  := LWB encoded;
         INT pos         := LWB encoded;
         INT max pos     := UPB encoded;
         INT max encoded := max pos - 3;
         WHILE pos <= UPB encoded
         DO
             IF encoded[ pos ] /= "%" AND pos <= max encoded
             THEN
                 # not a coded character #
                 result[ result pos ] := encoded[ pos ];
                 pos +:= 1
             ELSE
                 # have an encoded character #
                 result[ result pos ] := REPR ( ( 16 * hex value( encoded[ pos + 1 ] ) )
                                              +        hex value( encoded[ pos + 2 ] )
                                             );
                 pos +:= 3
             FI;
             result pos +:= 1
         OD;
         result[ LWB result : result pos - 1 ]
     END # url decode # ;

# test the url decode procedure #
print( ( url decode( "http%3A%2F%2Ffoo%20bar%2F" ),                 newline ) );
print( ( url decode( "google.com/search?q=%60Abdu%27l-Bah%C3%A1" ), newline ) )
