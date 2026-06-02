BEGIN # hamming numbers translation of Julia "processing an error band" sample #

    PR precision 1000 PR # sets the number of digits for LONG LONG INT         #
                         # should be enough for hamming numbers up to 10^9     #
    MODE HBAND = STRUCT( REAL v, [ 1 : 3 ]INT p );

    PRIO =:= = 9;
    OP   =:= = ( REF HBAND swap a, with b )REF HBAND:
         BEGIN HBAND t := with b; with b := swap a; swap a := t END;

    PROC sort descending bands = ( REF[]HBAND a, INT lb, ub )VOID:
         IF ub > lb
         THEN                            # more than one element, so must sort #
            INT left  := lb;
            INT right := ub;
            # choosing the middle element of the array as the pivot            #
            HBAND pivot := a[ left + ( ( right + 1 ) - left ) OVER 2 ];
            WHILE
                WHILE IF left  <= ub THEN v OF a[ left  ] > v OF pivot ELSE FALSE FI
                DO
                    left  +:= 1
                OD;
                WHILE IF right >= lb THEN v OF a[ right ] < v OF pivot ELSE FALSE FI
                DO
                    right -:= 1
                OD;
                left <= right
            DO
                a[ left  ] =:= a[ right ];
                left       +:= 1;
                right      -:= 1
            OD;
            sort descending bands( a, lb,      right );
            sort descending bands( a, left, ub       )
         FI # sort descending bands # ;

    PROC ceil = ( REAL x )INT: IF INT i = ENTIER x; x = i THEN i ELSE i + 1 FI;

    REAL log10of2 = log( 2 );
    PROC log2 = ( REAL x )REAL: log( x ) / log10of2;

    PROC nthhamming = ( INT n )[]INT:
         IF   # take care of trivial cases too small for band size estimation to work... #
              n < 1 THEN print(("nthhamming:  argument must be greater than zero!!!",newline));stop
         ELIF n < 2 THEN (0, 0, 0)
         ELIF n < 3 THEN (1, 0, 0)
         ELSE # larger cases #

              # some constants... #
              REAL log2of3 = log2(3), log2of5 = log2(5);
              REAL fctr = 6.0 * log2of3 * log2of5, crctn = log2(sqrt(30));
              REAL log2est = (fctr * n)^(1.0 / 3.0) - crctn; # log2 answer from WP formula #
              REAL log2hi  = log2est + 1.0 / log2est, width = 2.0 / log2est; # up to 2X higher/lower #

              # loop to find the count of regular numbers and band of possible candidates... #
              INT count   := 0;
              [ 1 : 20 + ENTIER log2est ]HBAND band;
              INT bandpos := 0;
              FOR fives FROM 0 TO ceil(log2hi / log2of5) - 1 DO
                  REAL log2p     = log2hi - fives * log2of5;
                  FOR threes FROM 0 TO ceil(log2p / log2of3) - 1 DO
                      REAL log2q = log2p - threes * log2of3;
                      INT  twos  = ENTIER log2q;
                      REAL frac  = log2q - twos;
                      count    +:= twos + 1;
                      IF frac <= width THEN
                         band[ bandpos +:= 1 ] := (log2hi - frac, (twos, threes, fives))
                      FI
                  OD
              OD;

              # process the band found including checks for validity and range... #
              IF n > count
              THEN print(("nthhamming:  band high estimate is too low!!!",newline));stop
              ELIF INT ndx = count - n + 1;
                   ndx > UPB band
              THEN print(("nthhamming:  band width estimate is too narrow!!!",newline));stop
              ELSE # sort into descending order #
                   sort descending bands( band, 1, bandpos );
                   # get and return the answer... #
                   p OF band[ndx]
              FI
         FI # nthhamming # ;

    PROC trival = ( []INT lr )LONG LONG INT:
         LONG LONG INT(2)^lr[1] * LONG LONG INT(3)^lr[2] * LONG LONG INT(5)^lr[3];

    PROC print hamming = ( STRING which, INT n )VOID:
         BEGIN
             []INT p = nthhamming( n );
             print( ( "Hamming number ", which, ": " ) );
             print( ( "2^" + whole( p[ 1 ], 0 ), " * 3^" + whole( p[ 2 ], 0 ), " * 5^", whole( p[ 3 ], 0 ) ) );
             IF n <= 1 000 000 000 THEN print( ( newline,"                      ", whole( trival( p ), 0 ) ) ) FI;
             print( ( newline ) )
         END # print hamming # ;

    FOR x TO 20 DO print( ( whole( trival( nthhamming( x ) ), 0 ), " " ) ) OD; print( ( newline ) );
    print hamming( " 1691",              1691 );
    print hamming( " 10^6",         1 000 000 );
    print hamming( " 10^9",     1 000 000 000 );
    IF max int OVER 1 000 000 > 1 000 000 THEN
        print hamming( "10^12", 1 000 000 * 1 000 000 )
    FI
END
