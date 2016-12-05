# as the numbers required for finding the first 20 primes are quite large, #
# we use Algol 68G's LONG LONG INT with a precision of 100 digits          #
PR precision 100 PR

# mode to hold fractions #
MODE FRACTION = STRUCT( INT numerator, INT denominator );

# define / between two INTs to yield a FRACTION #
OP / = ( INT a, b )FRACTION: ( a, b );

# mode to define a FRACTRAN progam #
MODE FRACTRAN = STRUCT( FLEX[0]FRACTION data
                      , LONG LONG INT   n
                      , BOOL            halted
                      );
# prepares a FRACTRAN program for use - sets the initial value of n and halted to FALSE #
PRIO STARTAT = 1;
OP   STARTAT = ( REF FRACTRAN f, INT start )REF FRACTRAN:
BEGIN
    halted OF f := FALSE;
         n OF f := start;
    f
END;

# sets n OF f to the next number in the sequence or sets halted OF f to TRUE if the sequence has ended #
OP NEXT = ( REF FRACTRAN f )LONG LONG INT:
    IF halted OF f
    THEN n OF f := 0
    ELSE
        BOOL          found  := FALSE;
        LONG LONG INT result := 0;
        FOR pos FROM LWB data OF f TO UPB data OF f WHILE NOT found DO
            LONG LONG INT value       = n OF f * numerator OF ( ( data OF f )[ pos ] );
            INT           denominator = denominator OF ( ( data OF f )[ pos ] );
            IF found := ( value MOD denominator = 0 ) THEN result := value OVER denominator FI
        OD;
        IF NOT found THEN halted OF f := TRUE FI;
        n OF f := result
    FI ;

# generate and print the sequence of numbers from a FRACTRAN pogram #
PROC print fractran sequence = ( REF FRACTRAN f, INT start, INT limit )VOID:
BEGIN
    VOID( f STARTAT start );
    print( ( "0: ", whole( start, 0 ) ) );
    FOR i TO limit
    WHILE VOID( NEXT f );
          NOT halted OF f
    DO
        print( ( " " + whole( i, 0 ) + ": " + whole( n OF f, 0 ) ) )
    OD;
    print( ( newline ) )
END ;

# print the first 16 elements from the primes FRACTRAN program #
FRACTRAN pf := ( ( 17/91, 78/85, 19/51, 23/38, 29/33, 77/29, 95/23, 77/19, 1/17, 11/13, 13/11, 15/14,  15/2, 55/1 ), 0, FALSE );
print fractran sequence( pf, 2, 15 );

# find some primes using the pf FRACTRAN progam - n is prime for the members in the sequence that are 2^n #
INT primes found := 0;
VOID( pf STARTAT 2 );
INT pos := 0;
print( ( "seq position  prime sequence value", newline ) );
WHILE primes found < 20 AND NOT halted OF pf DO
    LONG LONG INT value      := NEXT pf;
    INT      power of 2 := 0;
    pos +:= 1;
    WHILE value MOD 2 = 0 AND value > 0 DO power of 2 PLUSAB 1; value OVERAB 2 OD;
    IF value = 1 THEN
        # found a prime #
        primes found +:= 1;
        print( ( whole( pos, -12 ) + " " + whole( power of 2, -6 ) + " (" + whole( n OF pf, 0 ) + ")", newline ) )
    FI
OD
