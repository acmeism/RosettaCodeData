BEGIN # generate 1000 random digits and find the largest/smallest numbers formed from 5 consecutive digits #
    [ 1 : 1000 ]CHAR digits;
    FOR i TO UPB digits DO digits[ i ] := REPR ( ENTIER ( next random * 10 ) + ABS "0" ) OD;
    STRING max number := digits[ 1 : 5 ];
    STRING min number := digits[ 1 : 5 ];
    FOR i FROM 2 TO UPB digits - 4 DO
        STRING next number = digits[ i : i + 4 ];
        IF next number > max number
        THEN
            # found a new higher number #
            max number := next number
        FI;
        IF next number < min number
        THEN
            # found a new lower number #
            min number := next number
        FI
    OD;
    print( ( "Largest  5 consecutive digits from 1000 random digits: ", max number, newline ) );
    print( ( "Smallest 5 consecutive digits from 1000 random digits: ", min number, newline ) )
END
