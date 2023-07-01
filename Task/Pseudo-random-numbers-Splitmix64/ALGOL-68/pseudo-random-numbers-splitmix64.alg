BEGIN # generate some pseudo random numbers using Splitmix64 #
    # note that although LONG INT is 64 bits in Algol 68G, LONG BITS is longer than 64 bits #
    LONG BITS mask 64    = LONG 16rffffffffffffffff;
    LONG BITS state     := 16r1234567;
    LONG INT  one shl 64 = ABS ( LONG 16r1 SHL 64 );
    # sets the state to the specified seed value #
    PROC seed = ( LONG INT num )VOID: state := BIN num;
    # XOR and assign convenience operator #
    PRIO XORAB = 1;
    OP   XORAB = ( REF LONG BITS x, LONG BITS v )REF LONG BITS:
         x := ( x XOR v ) AND mask 64;
    # add a LONG BITS value to a LONG BITS #
    OP   +:= = ( REF LONG BITS r, LONG BITS v )REF LONG BITS:
         r := SHORTEN ( BIN ( LENG ABS r + LENG ABS v ) AND mask 64 );
    # multiplies a LONG BITS value by a LONG BITS value #
    OP   *:= = ( REF LONG BITS r, LONG BITS v )REF LONG BITS:
         r := SHORTEN ( BIN ( ABS LENG r * LENG ABS v ) AND mask 64 );
    # gets the next pseudo random integer #
    PROC next int = LONG INT:
         BEGIN
            state +:= LONG 16r9e3779b97f4a7c15;
            LONG BITS z := state;
            z XORAB ( z SHR 30 );
            z *:= LONG 16rbf58476d1ce4e5b9;
            z XORAB ( z SHR 27 );
            z *:= LONG 16r94d049bb133111eb;
            z XORAB ( z SHR 31 );
            ABS z
         END # next int # ;
    # gets the next pseudo random real #
    PROC next float = LONG REAL: next int / one shl 64;
    BEGIN # task test cases #
        seed( 1234567 );
        print( ( whole( next int, 0 ), newline ) ); #  6457827717110365317 #
        print( ( whole( next int, 0 ), newline ) ); #  3203168211198807973 #
        print( ( whole( next int, 0 ), newline ) ); #  9817491932198370423 #
        print( ( whole( next int, 0 ), newline ) ); #  4593380528125082431 #
        print( ( whole( next int, 0 ), newline ) ); # 16408922859458223821 #
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
