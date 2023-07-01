# parse the command line - ignore errors                                      #
INT  emirp from  :=  1;        # lowest emirp required                        #
INT  emirp to    := 10;        # highest emirp required                       #
BOOL value range := FALSE;     # TRUE if the range is the value of the emirps #
                               # FALSE if the range is the ordinal of the     #
                               # emirps                                       #
INT  max number  := 1 000 000; # sieve size                                   #
# returns s converted to an integer - does not check s is a valid integer     #
PROC to int = ( STRING s )INT:
     BEGIN
        INT result := 0;
        FOR ch pos FROM LWB s TO UPB s DO
            result *:= 10;
            result +:= ABS s[ ch pos ] - ABS "0"
        OD;
        result
     END # to int # ;
FOR arg pos TO argc DO
    IF   argv( arg pos ) = "FROM"    THEN
        emirp from  := to int( argv( arg pos + 1 ) )
    ELIF argv( arg pos ) = "TO"      THEN
        emirp to    := to int( argv( arg pos + 1 ) )
    ELIF argv( arg pos ) = "VALUE"   THEN
        value range := TRUE
    ELIF argv( arg pos ) = "ORDINAL" THEN
        value range := FALSE
    ELIF argv( arg pos ) = "SIEVE"   THEN
        max number  := to int( argv( arg pos + 1 ) )
    FI
OD;

# construct a sieve of primes up to the maximum number required for the task  #
PR read "primes.incl.a68" PR
[]BOOL is prime = PRIMESIEVE max number;

# return TRUE if p is an emirp, FALSE otherwise                               #
PROC is emirp = ( INT p )BOOL:
     IF NOT is prime[ p ] THEN
        FALSE
     ELSE
        # reverse the digits of p, if this is a prime different from p,       #
        # p is an emirp                                                       #
        INT q    := 0;
        INT rest := ABS p;
        WHILE rest > 0 DO
            q    TIMESAB 10;
            q    PLUSAB  rest MOD 10;
            rest OVERAB  10
        OD;
        is prime[ q ] AND q /= p
     FI # is emirp # ;

# generate the required emirp list                                            #
IF value range THEN
    # find emirps with values in the specified range                          #
    print( ( "emirps between ", whole( emirp from, 0 ), " and ", whole( emirp to, 0 ), ":" ) );
    FOR p FROM emirp from TO emirp to DO
        IF is emirp( p ) THEN
            print( ( " ", whole( p, 0 ) ) )
        FI
    OD
ELSE
    # find emirps with ordinals in the specified range                        #
    INT emirp count := 0;
    IF emirp from = emirp to THEN
        print( ( "emirp ", whole( emirp from, 0 ), ":" ) )
    ELSE
        print( ( "emirps ", whole( emirp from, 0 ), " to ", whole( emirp to, 0 ), ":" ) )
    FI;
    FOR p TO max number WHILE emirp count < emirp to DO
        IF is emirp( p ) THEN
            # have another emirp                                              #
            emirp count +:= 1;
            IF emirp count >= emirp from THEN
                print( ( " ", whole( p, 0 ) ) )
            FI
        FI
    OD
FI;
print( ( newline ) )
