BEGIN # Calculate members of the Calkin-Wilf sequence - translation of the Nim sample via EasyLang #

    INT  n := 0, d := 0;

    PROC first cw = VOID:
         BEGIN
            n := 1;
            d := 1
         END # first cw # ;

    PROC next cw = VOID:
         BEGIN
            n    := 2 * ( n OVER d ) * d + d - n;
            INT t = n;
            n    := d;
            d    := t
         END # next cw # ;

    print( ( "The first 20 elements of the Calkin-Wilf sequence are:", newline, "    " ) );
    first cw;
    FOR i TO 20 DO
        print( ( " ", whole( n, 0 ), "/", whole( d, 0 ) ) );
        next cw
    OD;
    print( ( newline, "Position of 83116/51639 in the sequence: " ) );
    BEGIN
        first cw;
        INT pos := 1;
        WHILE n /= 83116 OR d /= 51639 DO
            next cw;
            pos +:= 1
        OD;
        print( ( whole( pos, 0 ), newline ) )
    END
END
