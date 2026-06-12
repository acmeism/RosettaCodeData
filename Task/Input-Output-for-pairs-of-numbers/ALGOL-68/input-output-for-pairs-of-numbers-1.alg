# read a number from stand in then read and add that many pairs of numbers from stand in      #
# and write the sum to stand out. If non integer data is supplied, a runtime error will occur #
TO ( INT n; read( ( n, newline ) ); n ) DO
    INT a, b;
    read( ( a, b, newline ) );
    print( ( a + b, newline ) )
OD
