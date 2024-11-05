BEGIN # construct some Farey Sequences and calculate their lengths       #
    # prints an element of a Farey Sequence                              #
    PROC print element = ( INT a, b )VOID:
         print( ( " ", whole( a, 0 ), "/", whole( b, 0 ) ) );
    # returns the length of the Farey Sequence of order n, optionally    #
    #         printing it                                                #
    PROC farey sequence length = ( INT n, BOOL print sequence )INT:
         IF n < 1 THEN 0
         ELSE
            INT a := 0, b := 1, c := 1, d := n;
            IF print sequence THEN
                print( ( whole( n, -2 ), ":" ) );
                print element( a, b )
            FI;
            INT length := 1;
            WHILE c <= n DO
                INT k     = ( n + b ) OVER d;
                INT old a = a, old b = b;
                a := c;
                b := d;
                c := ( k * c ) - old a;
                d := ( k * d ) - old b;
                IF print sequence THEN print element( a, b ) FI;
                length +:= 1
            OD;
            IF print sequence THEN print( ( newline ) ) FI;
            length
         FI # farey sequence length # ;
    # task #
    FOR i TO 11 DO VOID( farey sequence length( i, TRUE ) ) OD;
    FOR n FROM 100 BY 100 TO 1 000 DO
        print( ( "Farey Sequence of order ", whole( n, -4 )
               , " has length: ", whole( farey sequence length( n, FALSE ), -6 )
               , newline
               )
             )
    OD
END
