BEGIN # generate some pseudo random numbers using PCG32 #
    # note that although LONG INT is 64 bits in Algol 68G, LONG BITS is longer than 64 bits #
    LONG BITS state     :=     LONG 16r853c49e6748fea9b;
    LONG INT  inc       := ABS LONG 16rda3e39cb94b95bdb;
    LONG BITS mask 64    =     LONG 16rffffffffffffffff;
    LONG BITS mask 32    =     LONG 16rffffffff;
    LONG BITS mask 31    =     LONG 16r7fffffff;
    LONG INT  one shl 32 = ABS ( LONG 16r1 SHL 32 );
    # XOR and assign convenience operator #
    PRIO XORAB = 1;
    OP   XORAB = ( REF LONG BITS x, LONG BITS v )REF LONG BITS: x := ( x XOR v ) AND mask 64;
    # initialises the state to the specified seed #
    PROC seed = ( LONG INT seed state, seed sequence )VOID:
         BEGIN
            state := 16r0;
            inc   := ABS ( ( ( BIN seed sequence SHL 1 ) OR 16r1 ) AND mask 64 );
            next int;
            state := SHORTEN ( BIN ( ABS state + seed state ) AND mask 64 );
            next int
         END # seed # ;
    # gets the next pseudo random integer #
    PROC next int = LONG INT:
         BEGIN
            LONG BITS old     = state;
            LONG INT const    = LONG 6364136223846793005;
            state            := SHORTEN ( mask 64 AND BIN ( ( ABS old * LENG const ) + inc ) );
            LONG BITS x      := old;
            x XORAB ( old SHR 18 );
            BITS  xor shifted = SHORTEN ( mask 32 AND ( x SHR 27 ) );
            INT   rot         = SHORTEN ABS ( mask 32 AND ( old SHR 59 ) );
            INT   rot 2       = IF rot = 0 THEN 0 ELSE 32 - rot FI;
            BITS  xor shr    := SHORTEN ( mask 32 AND LENG ( xor shifted SHR rot ) );
            BITS  xor shl    := xor shifted;
            TO rot 2 DO
                xor shl      := SHORTEN ( ( mask 31 AND LENG xor shl ) SHL 1 )
            OD;
            ABS ( LENG xor shr OR LENG xor shl )
         END # next int # ;
    # gets the next pseudo random real #
    PROC next float = LONG REAL: next int / one shl 32;
    BEGIN # task test cases #
        seed( 42, 54 );
        print( ( whole( next int, 0 ), newline ) ); # 2707161783 #
        print( ( whole( next int, 0 ), newline ) ); # 2068313097 #
        print( ( whole( next int, 0 ), newline ) ); # 3122475824 #
        print( ( whole( next int, 0 ), newline ) ); # 2211639955 #
        print( ( whole( next int, 0 ), newline ) ); # 3215226955 #
        # count the number of occurances of 0..4 in a sequence of pseudo random reals scaled to be in [0..5) #
        seed( 987654321, 1 );
        [ 0 : 4 ]INT counts; FOR i FROM LWB counts TO UPB counts DO counts[ i ] := 0 OD;
        TO 100 000 DO counts[ SHORTEN ENTIER ( next float * 5 ) ] +:= 1 OD;
        FOR i FROM LWB counts TO UPB counts DO
            print( ( whole( i, -2 ), ": ", whole( counts[ i ], -6 ) ) )
        OD;
        print( ( newline ) )
    END
END
