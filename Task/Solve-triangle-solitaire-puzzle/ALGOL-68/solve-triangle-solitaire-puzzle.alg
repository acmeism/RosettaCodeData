BEGIN # solve a triangle solitaire puzzle - translation of the Go sample     #

    MODE SOLUTION = STRUCT( INT peg, over, land );
    MODE MOVE     = STRUCT( INT from, to );

    INT number of pegs = 15;
    INT empty start   := 1;

    [ number of pegs ]BOOL board;
    [][]MOVE jump moves
        = ( []MOVE( (  2,  4 ), (  3,  6 ) )
          , []MOVE( (  4,  7 ), (  5,  9 ) )
          , []MOVE( (  5,  8 ), (  6, 10 ) )
          , []MOVE( (  2,  1 ), (  5,  6 ), (  7, 11 ), (  8, 13 ) )
          , []MOVE( (  8, 12 ), (  9, 14 ) )
          , []MOVE( (  3,  1 ), (  5,  4 ), (  9, 13 ), ( 10, 15 ) )
          , []MOVE( (  4,  2 ), (  8,  9 ) )
          , []MOVE( (  5,  3 ), (  9, 10 ) )
          , []MOVE( (  5,  2 ), (  8,  7 ) )
          , []MOVE( MOVE(  9,  8 ) )
          , []MOVE( MOVE( 12, 13 ) )
          , []MOVE( (  8,  5 ), ( 13, 14 ) )
          , []MOVE( (  8,  4 ), (  9,  6 ), ( 12, 11 ), ( 14, 15 ) )
          , []MOVE( (  9,  5 ), ( 13, 12 ) )
          , []MOVE( ( 10,  6 ), ( 14, 13 ) )
          );

    [ number of pegs ]SOLUTION solutions;
    INT s size     := 0;
    INT backtracks := 0;

    PROC init board = VOID:
         BEGIN
            FOR i TO number of pegs DO
                board[ i ] := TRUE
            OD;
            board[ empty start ] := FALSE
         END; # init board #

    PROC init solution = VOID:
         BEGIN
            s size     := 0;
            backtracks := 0
         END; # init solutions #

    PROC split solution = ( REF INT peg, over, land, SOLUTION sol )VOID:
         BEGIN
            peg := peg OF sol; over := over OF sol; land := land OF sol
         END; # split solution #

    PROC split move = ( REF INT from, to, MOVE mv )VOID:
         BEGIN
            from := from OF mv; to := to OF mv
         END; # split move #

    OP   TOHEX = ( INT v )CHAR:
         IF v < 10 THEN REPR ( ABS "0" + v ) ELSE REPR ( ABS "A" + ( v - 10 ) ) FI;

    PROC draw board = VOID:
         BEGIN
            PROC println = ( STRING s )VOID: print( ( s, newline ) );
            [ number of pegs ]CHAR pegs;
            FOR i TO number of pegs DO
                pegs[ i ] := IF board[ i ] THEN TOHEX i ELSE "." FI
            OD;
            println( "       " + pegs[ 1 ] );
            println( "      " + pegs[ 2 ] + " " + pegs[ 3 ] );
            println( "     " + pegs[ 4 ] + " " + pegs[ 5 ] + " " + pegs[ 6 ] );
            println( "    " + pegs[ 7 ] + " " + pegs[ 8 ] + " " + pegs[ 9 ] + " " + pegs[ 10 ] );
            println( "   " + pegs[ 11 ] + " " + pegs[ 12 ] + " " + pegs[ 13 ] + " " + pegs[ 14 ] + " " + pegs[ 15 ] )
         END; # draw board #

    PROC solved = BOOL: s size = number of pegs - 2;

    PROC solve = VOID:
         IF NOT solved THEN
            BOOL have solution := FALSE;
            FOR peg TO number of pegs WHILE NOT have solution DO
                IF board[ peg ] THEN
                    []MOVE jm = jump moves[ peg ];
                    FOR mv pos FROM LWB jm TO UPB jm WHILE NOT have solution DO
                        INT over, land;
                        split move( over, land, jm[ mv pos ] );
                        IF board[ over ] AND NOT board[ land ] THEN
                            []BOOL save board = board;
                            board[ peg  ] := FALSE;
                            board[ over ] := FALSE;
                            board[ land ] := TRUE;
                            solutions[ s size +:= 1 ] := ( peg, over, land );
                            solve;
                            IF NOT ( have solution := solved ) THEN
                                # not solved - backtrack                     #
                                backtracks +:= 1;
                                board       := save board;
                                s size     -:= 1
                            FI
                        FI
                    OD
                FI
            OD
         FI; # solve #


    FOR start peg TO number of pegs DO
        empty start := start peg;
        init board;
        init solution;
        solve;
        IF empty start = 1 THEN
            init board;
            draw board
        FI;
        print( ( "Starting with peg ", TOHEX empty start, " removed" ) );
        IF empty start = 1 THEN
            print( ( newline, newline ) );
            FOR pos TO s size DO
                SOLUTION solution = solutions[ pos ];
                INT peg, over, land;
                split solution( peg, over, land, solution );
                board[ peg  ] := FALSE;
                board[ over ] := FALSE;
                board[ land ] := TRUE;
                draw board;
                print( ( "Peg ", TOHEX peg, " jumped over ", TOHEX over, " to land on ", TOHEX land ) );
                print( ( newline, newline ) )
            OD
        FI;
        print( ( whole( backtracks, -8 ), " backtracks were required", newline ) )
    OD
END
