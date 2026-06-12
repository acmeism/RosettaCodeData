# read a number from stand in then read and add that many pairs of numbers from stand in      #
# and write the sum to stand out. If non integer data is supplied, a runtime error will occur #
# This version does not allow the pairs of numbers to be spread over several lines            #
STRING line;
FILE   numbers;
associate( numbers, line );
TO ( INT n
   ; read( ( line, newline ) )
   ; reset( numbers )
   ; get( numbers, ( n ) )
   ; n
   )
DO
    INT a, b;
    read( ( line, newline ) );
    reset( numbers );
    get( numbers, ( a, b ) );
    print( ( a + b, newline ) )
OD
