BEGIN # Chinese remainder theorewm - translated from the C sample             #

    PROC mul inv = ( INT a in, b in )INT:
         IF b in = 1
         THEN 1
         ELSE
            INT b0 = b in;
            INT a := a in, b := b in, x0 := 0, x1 := 1;
            WHILE a > 1 DO
                IF b = 0 THEN
                    print( ( "Numbers not pairwise coprime", newline ) ); stop
                FI;
                INT q = a OVER b;
                INT t;
                t := b; b := a MOD b; a := t;
                t := x0; x0 := x1 - q * x0; x1 := t
            OD;
            IF x1 < 0 THEN x1 + b0 ELSE x1 FI
         FI # mul inv # ;

    PROC chinese remainder = ( []INT n, a )INT:
         IF LWB n /= LWB a OR UPB n /= UPB a OR ( UPB a - LWB a ) + 1 < 1
         THEN print( ( "Array bounds mismatch or empty arrays", newline ) ); stop
         ELSE
            INT prod := 1, sum := 0;
            FOR i FROM LWB n TO UPB n DO prod *:= n[ i ] OD;
            IF prod = 0 THEN
                print( ( "Numbers not pairwise coprime", newline ) ); stop
            FI;
            FOR i FROM LWB n TO UPB n DO
                INT p = prod OVER n[ i ];
                sum +:= a[ i ] * mul inv( p, n[ i ] ) * p
            OD;
            sum MOD prod
         FI # chinese remainder # ;

    print( ( whole( chinese remainder( ( 3, 5, 7 ), ( 2, 3, 2 ) ), 0 ), newline ) )

END
