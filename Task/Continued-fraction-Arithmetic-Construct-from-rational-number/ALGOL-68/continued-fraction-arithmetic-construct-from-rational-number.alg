BEGIN # construct continued fraction representations of rational numbers #
      # Translated from the C sample                                     #
      # Uses code from the Arithmetic/Rational task                      #

    # Code from the Arithmetic/Rational task                         #
    # ============================================================== #

    MODE FRAC = STRUCT( INT num #erator#,  den #ominator#);

    PROC gcd = (INT a, b) INT: # greatest common divisor #
       (a = 0 | b |: b = 0 | a |: ABS a > ABS b  | gcd(b, a MOD b) | gcd(a, b MOD a));

    PRIO // = 9; # higher then the ** operator #
    OP // = (INT num, den)FRAC: ( # initialise and normalise #
       INT common = gcd(num, den);
       IF den < 0 THEN
         ( -num OVER common, -den OVER common)
       ELSE
         ( num OVER common, den OVER common)
       FI
     );

    # ============================================================== #
    # end code from the Arithmetic/Rational task                     #

    []FRAC examples = ( 1//2, 3//1, 23//8, 13//11, 22//7, -151//77 );
    []FRAC sqrt2    = ( 14142//10000, 141421//100000, 1414214//1000000, 14142136//10000000 );
    []FRAC pif      = ( 31//10, 314//100, 3142//1000, 31428//10000
                      , 314285//100000, 3142857//1000000, 31428571//10000000, 314285714//100000000
                      );

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
    # shows the continued fractions for the elements of f seq #
    PROC show r2cf = ( STRING legend, []FRAC f seq )VOID:
         BEGIN
            print( ( legend ) );
            FOR i FROM LWB f seq TO UPB f seq DO
                INT num := num OF f seq[ i ];
                INT den := den OF f seq[ i ];
                print( ( newline, "For N = ", whole( num , 0 ), ", D = ", whole( den , 0 ), " :" ) );
                WHILE den /= 0 DO
                    print( ( " ", whole( r2cf( num, den ), 0 ) ) )
                OD
            OD
         END # show r2cf # ;
    BEGIN # task #
        show r2cf( "Running the examples :", examples );
	print( ( newline, newline ) );
        show r2cf( "Running for root2 :", sqrt2 );
	print( ( newline, newline ) );
	show r2cf( "Running for pi :", pif );
        print( ( newline ) )
    END
END
