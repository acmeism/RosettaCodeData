BEGIN # generate some pseudo random numbers using Xorshift star #
    # note that although LONG INT is 64 bits in Algol 68G, LONG BITS is longer than 64 bits #
    LONG BITS state;
    LONG INT  const      = ABS LONG 16r2545f4914f6cdd1d;
    LONG INT  one shl 32 = ABS ( LONG 16r1 SHL 32 );
    # sets the state to the specified seed value #
    PROC seed = ( LONG INT num )VOID: state := BIN num;
    # XOR and assign convenience operator #
    PRIO XORAB = 1;
    OP   XORAB = ( REF LONG BITS x, LONG BITS v )REF LONG BITS: x := ( x XOR v ) AND LONG 16rffffffffffffffff;
    # gets the next pseudo random integer #
    PROC next int = LONG INT:
         BEGIN
            LONG BITS x := state;
            x XORAB ( x SHR 12 );
            x XORAB ( x SHL 25 );
            x XORAB ( x SHR 27 );
            state := x;
            SHORTEN ABS ( 16rffffffff AND BIN ( ABS x * LENG const ) SHR 32 )
         END # next int # ;
    # gets the next pseudo random real #
    PROC next float = LONG REAL: next int / one shl 32;
    BEGIN # task test cases #
        seed( 1234567 );
        print( ( whole( next int, 0 ), newline ) ); # 3540625527 #
        print( ( whole( next int, 0 ), newline ) ); # 2750739987 #
        print( ( whole( next int, 0 ), newline ) ); # 4037983143 #
        print( ( whole( next int, 0 ), newline ) ); # 1993361440 #
        print( ( whole( next int, 0 ), newline ) ); # 3809424708 #
        # count the number of occurances of 0..4 in a sequence of pseudo random reals scaled to be in [0..5) #
        seed( 987654321 );
        [ 0 : 4 ]INT counts; FOR i FROM LWB counts TO UPB counts DO counts[ i ] := 0 OD;
        TO 100 000 DO counts[ SHORTEN ENTIER ( next float * 5 ) ] +:= 1 OD;
        FOR i FROM LWB counts TO UPB counts DO
            print( ( whole( i, -2 ), ": ", whole( counts[ i ], -6 ) ) )
        OD;
        print( ( newline ) )
    END
END
