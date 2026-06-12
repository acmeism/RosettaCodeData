BEGIN # find a sequence of primes whose members are the smallest prime whose #
      # reciprocal can be added to the sum or the reciprocals of the         #
      # previous primes and the sum remain below 1                           #

    PR precision 5000 PR                # set the precision of LONG LONG INT #
    PR read "primes.incl.a68" PR                   # include prime utilities #

    # iterative Greatest Common Divisor routine, returns the gcd of m and n  #
    PROC gcd = ( LONG LONG INT m, n )LONG LONG INT:
         BEGIN
            LONG LONG INT a := ABS m, b := ABS n;
            WHILE b /= 0 DO
                LONG LONG INT new a = b;
                b        := a MOD b;
                a        := new a
            OD;
            a
        END # gcd # ;

# code from the Arithmetic/Rational task modified to use LONG LONG INT       #
 MODE FRAC = STRUCT( LONG LONG INT num #erator#,  den #ominator# );

  PROC lcm = ( LONG LONG INT a, b )LONG LONG INT:    # least common multiple #
   a OVER gcd(a, b) * b;

  PRIO // = 9;                                 # higher then the ** operator #
  OP // = ( LONG LONG INT num, den )FRAC: (       # initialise and normalise #
   LONG LONG INT common = gcd( num, den );
   IF den < 0 THEN
     ( -num OVER common, -den OVER common )
   ELSE
     ( num OVER common, den OVER common )
   FI
 );

 OP + = (FRAC a, b)FRAC: (
   LONG LONG INT common = lcm( den OF a, den OF b );
   FRAC result := ( common OVER den OF a * num OF a + common OVER den OF b * num OF b, common );
   num OF result//den OF result
 );

 OP +:= = (REF FRAC a, FRAC b)REF FRAC: ( a := a + b );

# end code from the Arithmetic/Rational task modified to use LONG LONG INT   #

    # the sequence starts with the reciprocal of the first prime > 0, i.e. 2 #
    LONG LONG INT one = 1;
    FRAC sum := one // LONG LONG 2;
    print( ( " 1: 2", newline ) );

    # each succeeding prime is the next prime > the denominator of the sum   #
    # divided by the difference of the denominator and the numerator         #
    FOR i FROM 2 TO 15 DO
        LONG LONG INT next := IF num OF sum + 1 = den OF sum
                              THEN den OF sum + 1
                              ELSE ( den OF sum OVER ( den OF sum - num OF sum ) ) + 1
                              FI;
        IF NOT ODD next THEN next +:= 1 FI;
        WHILE NOT is probably prime( next ) DO next +:= 2 OD;
        print( ( whole( i, -2 ), ": " ) );
        STRING prime text = whole( next, 0 );
        IF INT digits = ( UPB prime text - LWB prime text ) + 1;
            digits <= 40
        THEN
            print( ( prime text ) )
        ELSE
            print( ( prime text[ : LWB prime text + 19 ], "..."
                   , prime text[ UPB prime text - 19 : ], "   "
                   , whole( digits, -6 ), " digits"
                   )
                 )
        FI;
        print( ( newline ) );
        sum +:= one // next
    OD

END
