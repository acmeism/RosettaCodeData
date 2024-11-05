BEGIN # find some esthetic numbers: numbers whose successive digits differ by 1 #
    # returns TRUE if n is esthetic in the specified base, FALSE otherwise #
    PRIO ISESTHETIC = 1;
    OP   ISESTHETIC = ( INT n, base )BOOL:
         BEGIN
            INT  v             := ABS n;
            BOOL is esthetic   := TRUE;
            INT  prev digit    := v MOD base;
            v OVERAB base;
            WHILE v > 0 AND is esthetic
            DO
                INT next digit := v MOD base;
                is esthetic    := ABS ( next digit - prev digit ) = 1;
                prev digit     := next digit;
                v OVERAB base
            OD;
            is esthetic
         END # ISESTHETIC # ;
    # returns an array of the first n esthetic numbers in the specified base #
    PRIO ESTHETIC = 1;
    OP   ESTHETIC = ( INT n, base )[]INT:
         BEGIN
            [ 1 : n ]INT result;
            INT          e count := 0;
            FOR i WHILE  e count < n DO
                IF i ISESTHETIC base THEN result[ e count +:= 1 ] := i FI
            OD;
            result
         END # ESTHETIC # ;
    # returns a string erpresentation of n in the specified base, 2 <= base <= 16 must be TRUE #
    PRIO TOBASESTRING = 1;
    OP   TOBASESTRING = ( INT n, base )STRING:
         IF base < 2 OR base > 16
         THEN # invalid vbase #
             "?" + whole( n, 0 ) + ":" + whole( base, 0 ) + "?"
         ELSE
            INT    v      := ABS n;
            STRING digits  = "0123456789abcdef";
            STRING result := digits[ ( v MOD base ) + 1 ];
            WHILE ( v OVERAB base ) > 0 DO
                digits[ ( v MOD base ) + 1 ] +=: result
            OD;
            IF n < 0 THEN "-" +=: result FI;
            result
        FI # TOBASESTRING # ;
    # sets count to the number of esthetic numbers with length digits in base b less than max #
    # also displays the esthetic numbers #
    PROC show esthetic = ( INT number, base, length, max, REF INT count )VOID:
         IF length = 1
         THEN # number is esthetic #
             IF number <= max THEN
                 # number is in the required range #
                 print( ( " ", whole( number, 0 ) ) );
                 IF ( count +:= 1 ) MOD 9 = 0 THEN print( ( newline ) ) FI
             FI
         ELSE
             # find the esthetic numbers that start with number #
             INT digit  = number MOD base;
             INT prefix = number * base;
             IF digit > 0 THEN # can have a lower digit #
                 show esthetic( prefix + ( digit - 1 ), base, length - 1, max, count )
             FI;
             IF digit < base - 1 THEN # can have a higher digit #
                 show esthetic( prefix + ( digit + 1 ), base, length - 1, max, count )
             FI
         FI # show esthetic # ;
    BEGIN # task #
        # esthetic numbers from base * 4 to base * 6 for bases 2 to 16 #
        FOR base FROM 2 TO 16 DO
            INT e from = base * 4;
            INT e to   = base * 6;
            print( ( "Esthetic numbers ", whole( e from, 0 ), " to ", whole( e to, 0 ) ) );
            print( ( " in base ", whole( base, 0 ), newline ) );
            []INT e numbers = e to ESTHETIC base;
            print( ( "  " ) );
            FOR n FROM e from TO e to DO
                print( ( " ", e numbers[ n ] TOBASESTRING base ) )
            OD;
            print( ( newline ) )
        OD;
        # esthetic base 10 numbers between 1000 and 9999 #
        print( ( "Base 10 eshetic numbers between 1000 and 9999", newline ) );
        INT e count := 0;
        FOR i FROM 1000 TO 9999 DO
            IF i ISESTHETIC 10 THEN
                print( ( " ", whole( i, 0 ) ) );
                IF ( e count +:= 1 ) MOD 16 = 0 THEN print( ( newline ) ) FI
            FI
        OD;
        print( ( newline, newline ) );
        print( ( "Esthetic numbers between 100 000 000 and 130 000 000:", newline ) );
        e count := 0;
        show esthetic( 1, 10, 9, 130 000 000, e count );
        print( ( newline ) );
        print( ( "Found ", whole( e count, 0 ), " esthetic numbers", newline ) )
    END
END
