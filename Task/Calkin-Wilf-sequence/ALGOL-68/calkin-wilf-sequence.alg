BEGIN
    # Show elements 1-20 of the Calkin-Wilf sequence as rational numbers       #
    # also show the position of a specific element in the seuence              #
    # Uses code from the Arithmetic/Rational                                   #
    #    & Continued fraction/Arithmetic/Construct from rational number tasks  #


    # Code from the Arithmetic/Rational task                         #
    # ============================================================== #

    MODE FRAC = STRUCT( INT num #erator#,  den #ominator#);

    PROC gcd = (INT a, b) INT: # greatest common divisor #
       (a = 0 | b |: b = 0 | a |: ABS a > ABS b  | gcd(b, a MOD b) | gcd(a, b MOD a));

    PROC lcm = (INT a, b)INT: # least common multiple #
       a OVER gcd(a, b) * b;

    PRIO // = 9; # higher then the ** operator #
    OP // = (INT num, den)FRAC: ( # initialise and normalise #
       INT common = gcd(num, den);
       IF den < 0 THEN
         ( -num OVER common, -den OVER common)
       ELSE
         ( num OVER common, den OVER common)
       FI
     );

    OP + = (FRAC a, b)FRAC: (
       INT common = lcm(den OF a, den OF b);
       FRAC result := ( common OVER den OF a * num OF a + common OVER den OF b * num OF b, common );
       num OF result//den OF result
    );

    OP - = (FRAC a, b)FRAC: a + -b;
    OP - = (FRAC frac)FRAC: (-num OF frac, den OF frac);

    # ============================================================== #
    # end code from the Arithmetic/Rational task                     #

    # code from the Continued fraction/Arithmetic/Construct from rational number task #
    # ================================================================================#

    # returns the quotient of numerator over denominator and sets #
    #         numerator and denominator to the next values for    #
    #         the continued fraction                              #
    PROC r2cf = ( REF INT numerator, REF INT denominator )INT:
         IF denominator = 0
         THEN 0
         ELSE INT quotient      := numerator OVER denominator;
              INT prev numerator = numerator;
              numerator         := denominator;
              denominator       := prev numerator MOD denominator;
	      quotient
         FI # r2cf # ;

    # ====================================================================================#
    # end code from the Continued fraction/Arithmetic/Construct from rational number task #

    # Additional FRACrelated operators                               #
    OP /     = ( FRAC a, b )FRAC: ( num OF a * den OF b ) // ( num OF b * den OF a );
    OP FLOOR = ( FRAC a )INT: num OF a OVER den OF a;
    OP +     = ( INT a, FRAC b )FRAC: ( a // 1 ) + b;

    FRAC one = 1 // 1;

    # returns the first n elements of the Calkin-Wilf sequence       #
    PROC calkin wilf = ( INT n )[]FRAC:
         BEGIN
            [ 1 : n ]FRAC q;
            IF n > 0 THEN
                q[ 1 ] := 1 // 1;
                FOR i FROM 2 TO UPB q DO
                    q[ i ] := one / ( ( 2 * FLOOR q[ i - 1 ] ) + one - q[ i - 1 ] )
                OD
             FI;
             q
         END # calkin wilf # ;

    # returns the position of a FRAC in the Calkin-Wilf sequence by computing its #
    # continued fraction representation and converting that to a bit string       #
    # - the position must fit in a 2-bit number                                   #
    PROC position in calkin wilf sequence = ( FRAC f )INT:
         IF INT result := 0;
            [ 1 : 32 ]INT cf; FOR i FROM LWB cf TO UPB cf DO cf[ i ] := 0 OD;
            INT num := num OF f;
            INT den := den OF f;
            INT cf length := 0;
            FOR i FROM LWB cf WHILE den /= 0 DO
                cf[ cf length := i ] := r2cf( num, den )
            OD;
            NOT ODD cf length
         THEN # the continued fraction does not have an odd length #
            -1
         ELSE # the continued fraction has an odd length so we can compute the seuence length #
            # build the number by alternating d 1s and 0s where d is the digits of the        #
            # continued fraction, starting at the least significant                           #
            INT digit := 1;
            FOR d pos FROM cf length BY -1 TO 1 DO
                TO cf[ d pos ] DO
                    result *:= 2 +:= digit
                OD;
                digit := IF digit = 0 THEN 1 ELSE 0 FI
            OD;
            result
        FI # position in calkin wilf sequence # ;

    BEGIN # task #
        # get and show the first 20 Calkin-Wilf sequence numbers #
        []FRAC cw = calkin wilf( 20 );
        print( ( "The first 20 elements of the Calkin-Wilf sequence are:", newline, "    " ) );
        FOR n FROM LWB cw TO UPB cw DO
            FRAC sn = cw[ n ];
            print( ( " ", whole( num OF sn, 0 ), "/", whole( den OF sn, 0 ) ) )
        OD;
        print( ( newline ) );
        # show the position of a specific element in the sequence #
        print( ( "Position of 83116/51639 in the sequence: "
               , whole( position in calkin wilf sequence( 83116//51639 ), 0 ), newline
               )
             )
    END
END
