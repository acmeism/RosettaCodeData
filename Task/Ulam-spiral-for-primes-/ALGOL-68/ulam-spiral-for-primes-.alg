BEGIN # construct a Ulam spiral for primes                                   #
    PR read "primes.incl.a68" PR                   # include prime utilities #
    # prints a Ulam spiral for primes with the specified width,              #
    #        starting from init. Primes will be indicated by prime char and  #
    #        non-primes by composite char. The center of the spiral will be  #
    #        indicated by center char - unless the center value is prime     #
    PROC print ulam spiral for primes = ( INT width, init, CHAR prime char, composite char, center char )VOID:
         IF width >= 1 THEN
             INT n = IF ODD width THEN width ELSE width + 1 FI;
             []BOOL prime = PRIMESIEVE ( init + ( n * n ) );
             [ 1 : n, 1 : n ]CHAR spiral; FOR i TO n DO FOR j TO n DO spiral[ i, j ] := "_" OD OD;
             INT y := ( n + 1 ) OVER 2;
             INT x := y;
             INT v := init;
             spiral[ x, y ] := IF prime[ init ] THEN prime char ELSE center char FI;
             INT w := 0;
             WHILE x < 1 UPB spiral DO
                 w +:= 2;
                 x +:= 1;
                 y +:= 1;
                 FOR i TO w DO                                 #  right edge #
                     spiral[ x, y -:= 1 ] := IF prime[ v +:= 1 ] THEN prime char ELSE composite char FI
                 OD;
                 FOR i TO w DO                                 #    top edge #
                     spiral[ x -:= 1, y ] := IF prime[ v +:= 1 ] THEN prime char ELSE composite char FI
                 OD;
                 FOR i TO w DO                                 #   left edge #
                     spiral[ x, y +:= 1 ] := IF prime[ v +:= 1 ] THEN prime char ELSE composite char FI
                 OD;
                 FOR i TO w DO                                 # bottom edge #
                     spiral[ x +:= 1, y ] := IF prime[ v +:= 1 ] THEN prime char ELSE composite char FI
                 OD
             OD;
             FOR v pos TO width DO
                 FOR h pos TO width DO
                     print( ( spiral[ h pos, v pos ] ) )
                 OD;
                 print( ( newline ) )
             OD
         FI # ulam spiral for primes # ;

    print ulam spiral for primes( 35, 1, "#", " ", "+" )
END
