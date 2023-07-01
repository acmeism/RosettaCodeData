BEGIN # show members of the Padovan Sequence calculated in various ways #
    # returns the first n elements of the Padovan sequence by the       #
    #         recurance relation: P(n)=P(n-2)+P(n-3)	                #
    OP PADOVANI = ( INT n )[]INT:
       BEGIN
           [ 0 : n - 1 ]INT p; p[ 0 ] := p[ 1 ] := p[ 2 ] := 1;
           FOR i FROM 3 TO UPB p DO
               p[ i ] := p[ i - 2 ] + p[ i - 3 ]
           OD;
           p
       END; # PADOVANI #
    # returns the first n elements of the Padovan sequence by           #
    #         computing by truncation P(n)=floor(p^(n-1) / s + .5)      #
    #                where s = 1.0453567932525329623                    #
    #                  and p = the "plastic ratio"                      #
    OP PADOVANC = ( INT n )[]INT:
       BEGIN
           LONG REAL    s   = 1.0453567932525329623;
           LONG REAL    p   = 1.324717957244746025960908854;
           LONG REAL    pf := 1 / p;
           [ 0 : n - 1 ]INT result;
           FOR i FROM LWB result TO UPB result DO
               result[ i ] := SHORTEN ENTIER ( pf / s + 0.5 );
               pf         *:= p
           OD;
           result
       END; # PADOVANC #
    # returns the first n L System strings of the Padovan sequence      #
    OP PADOVANL = ( INT n )[]STRING:
       BEGIN
           [ 0 : n - 1 ]STRING l; l[ 0 ] := "A"; l[ 1 ] := "B"; l[ 2 ] := "C";
           FOR i FROM 3 TO UPB l DO
               l[ i ] := l[ i - 3 ] + l[ i - 2 ]
           OD;
           l
    END; # PADOVANC #
    # returns TRUE if a and b have the same values, FALSE otherwise     #
    OP = = ( []INT a, b )BOOL:
       IF LWB a /= LWB b OR UPB a /= UPB b
       THEN # rows are not the same size # FALSE
       ELSE
           BOOL result := TRUE;
           FOR i FROM LWB a TO UPB a WHILE result := a[ i ] = b[ i ] DO SKIP OD;
           result
       FI; # = #
    # returns the number of elements in a                               #
    OP LENGTH = ( []INT a )INT: ( UPB a - LWB a ) + 1;
    # returns the number of characters in s                             #
    OP LENGTH = ( STRING s )INT: ( UPB s - LWB s ) + 1;
    # returns a string representation of n                              #
    OP TOSTRING = ( INT n )STRING: whole( n, 0 );
    # generate 64 elements of the sequence and 32 L System values       #
    []INT    iterative  = PADOVANI 64;
    []INT    calculated = PADOVANC 64;
    []STRING l system   = PADOVANL 32;
    [ LWB l system : UPB l system ]INT l length;
    FOR i FROM LWB l length TO UPB l length DO l length[ i ] := LENGTH l system[ i ] OD;
    # first 20 terms                                                    #
    print( ( "First 20 terms of the Padovan Sequence", newline ) );
    FOR i FROM LWB iterative TO 19 DO
        print( ( " ", TOSTRING iterative[ i ] ) )
    OD;
    print( ( newline ) );
    print( ( "The first "
           , TOSTRING LENGTH iterative
           , " iterative and calculated values "
           , IF iterative = calculated THEN "are the same" ELSE "differ" FI
           , newline
           )
         );
    # print the first 10 values of the L System strings                 #
    print( ( newline, "First 10 L System strings", newline ) );
    FOR i FROM LWB l system TO 9 DO
        print( ( " ", l system[ i ] ) )
    OD;
    print( ( newline ) );
    print( ( "The first "
           , TOSTRING LENGTH l length
           , " iterative values and L System lengths "
           , IF l length = iterative[ LWB l length : UPB l length @ LWB l length ] THEN "are the same" ELSE "differ" FI
           ,  newline
           )
         )
END
