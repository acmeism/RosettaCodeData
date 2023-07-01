BEGIN # find wierd numbers - abundant but not semiperfect numbers - translation of Go #
    # returns the divisors of n in descending order #
    PROC divisors = ( INT n )[]INT:
         BEGIN
            INT max divs = 2 * ENTIER sqrt( n );
            [ 1 : max divs ]INT divs;
            [ 1 : max divs ]INT divs2;
            INT d pos := 0, d2 pos := 0;
            divs[ d pos +:= 1 ] := 1;
            FOR i FROM 2 WHILE i * i <= n DO
                IF n MOD i = 0 THEN
                    INT j = n OVER i;
                    divs[ d pos +:= 1 ] := i;
                    IF i /= j THEN divs2[ d2 pos +:= 1 ] := j FI
                FI
            OD;
            FOR i FROM d pos BY -1 WHILE i > 0 DO
                divs2[ d2 pos +:= 1 ] := divs[ i ]
            OD;
            divs2[ 1 : d2 pos ]
         END # divisors # ;
    # returns TRUE if n with divisors divs, is abundant, FALSE otherwise #
    PROC abundant = ( INT n, []INT divs )BOOL:
         BEGIN
            INT sum := 0;
            FOR i FROM LWB divs TO UPB divs DO sum +:= divs[ i ] OD;
            sum > n
         END # abundant # ;
    # returns TRUE if n with divisors divs, is semiperfect, FALSE otherwise #
    PROC semiperfect = ( INT n, []INT divs, INT lb, ub )BOOL:
         IF   ub < lb
         THEN FALSE
         ELIF INT h = divs[ lb ];
              n < h
         THEN semiperfect( n,     divs, lb + 1, ub )
         ELIF n = h
         THEN TRUE
         ELIF semiperfect( n - h, divs, lb + 1, ub )
         THEN TRUE
         ELSE semiperfect( n,     divs, lb + 1, ub )
         FI # semiperfect # ;
    # returns a sieve where FALSE = abundant and not semiperfect #
    PROC sieve = ( INT limit )[]BOOL:
         BEGIN # Only interested in even numbers >= 2 #
            [ 1 : limit ]BOOL w; FOR i FROM 1 TO limit DO w[ i ] := FALSE OD;
            FOR i FROM 2 BY 2 TO limit DO
                IF NOT w[ i ] THEN
                    []INT divs = divisors( i );
                    IF NOT abundant( i, divs ) THEN
                        w[ i ] := TRUE
                    ELIF semiperfect( i, divs, LWB divs, UPB divs ) THEN
                        FOR j FROM i BY i TO limit DO w[ j ] := TRUE OD
                    FI
                FI
            OD;
            w
         END # sieve # ;
    BEGIN # task #
        []BOOL w = sieve( 17 000 );
        INT count := 0;
        INT max = 25;
        print( ( "The first 25 weird numbers are:", newline ) );
        FOR n FROM 2 BY 2 WHILE count < max DO
            IF NOT w[ n ] THEN
                print( ( whole( n, 0 ), " " ) );
                count +:= 1
            FI
        OD;
        print( ( newline ) )
    END
END
