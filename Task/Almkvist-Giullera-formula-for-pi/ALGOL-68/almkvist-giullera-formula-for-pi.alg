# Almkvist-Giullera formula for pi - translated from the C++ sample         #

PR precision 1024 PR                    # set precision for LONG LONG modes #
MODE INTEGER = LONG LONG INT;
MODE FLOAT   = LONG LONG REAL;

INTEGER zero = 0, one = 1, ten = 10;

# iterative Greatest Common Divisor routine, returns the gcd of m and n #
PROC gcd = ( INTEGER m, n )INTEGER:
     BEGIN
        INTEGER a := ABS m, b := ABS n;
        WHILE b /= 0 DO
            INTEGER new a = b;
            b        := a MOD b;
            a        := new a
        OD;
        a
    END # gcd # ;

# code from the Arithmetic/Rational task modified to use LONG LONG INT       #
 MODE RATIONAL = STRUCT( INTEGER num #erator#,  den #ominator# );

  PROC lcm = ( INTEGER a, b )INTEGER:                # least common multiple #
   a OVER gcd(a, b) * b;

  PRIO // = 9;                                 # higher then the ** operator #
  OP // = ( INTEGER num, den )RATIONAL: (         # initialise and normalise #
   INTEGER common = gcd( num, den );
   IF den < 0 THEN
     ( -num OVER common, -den OVER common )
   ELSE
     ( num OVER common, den OVER common )
   FI
 );

 OP + = (RATIONAL a, b)RATIONAL: (
   INTEGER common = lcm( den OF a, den OF b );
   RATIONAL result := ( common OVER den OF a * num OF a + common OVER den OF b * num OF b, common );
   num OF result//den OF result
 );

 OP +:= = (REF RATIONAL a, RATIONAL b)REF RATIONAL: ( a := a + b );

# end code from the Arithmetic/Rational task modified to use LONG LONG INT   #

OP / = ( FLOAT f, RATIONAL r )FLOAT: ( f * den OF r ) / num OF r;

INTEGER ag factorial n    := 1;
INT     ag last factorial := 0;
# returns factorial n, using ag factorial n and ag last factorial to reduce #
# the number of calculations                                                #
PROC ag factorial = ( INT n )INTEGER:
     BEGIN
         IF n < ag last factorial THEN
             ag last factorial := 0;
             ag factorial n    := 1
         FI;
         WHILE ag last factorial < n DO
             ag factorial n *:= ( ag last factorial +:= 1 )
         OD;
         ag factorial n
     END # ag gfgactorial # ;

# Return the integer portion of the nth term of Almkvist-Giullera sequence. #
PROC almkvist giullera = ( INT n )INTEGER:
    ag factorial( 6 * n ) * 32 * ( 532 * n * n + 126 * n + 9 ) OVER ( ( ag factorial( n ) ^ 6 ) * 3 );

BEGIN
    print( (  "n |                  Integer portion of nth term", newline ) );
    print( (  "--+---------------------------------------------", newline ) );
    FOR n FROM 0 TO 9 DO
        print( ( whole( n, 0 ), " | ", whole( almkvist giullera( n ), -44 ), newline ) )
    OD;
    FLOAT    epsilon = FLOAT(10) ^ -70;
    FLOAT    prev   := 0, pi := 0;
    RATIONAL sum    := zero // one;
    FOR n FROM 0
    WHILE
        RATIONAL term = almkvist giullera( n ) // ( ten ^ ( 6 * n + 3 ) );
        sum +:= term;
        pi   := long long sqrt( FLOAT(1) / sum );
        ABS ( pi - prev ) >= epsilon
    DO
        prev := pi
    OD;
    print( ( newline, "Pi to 70 decimal places is:", newline ) );
    print( ( fixed( pi, -72, 70 ), newline ) )
END
