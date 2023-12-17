CO find the integers that can't be expressed as the sum of distinct squares
   it can be proved that if 120-324 can be expressed as the sum of distinct
   squares then all integers greater than 129 can be so expressed
   (see the link in the Wren sample) so we need to check that 129-324 can
   be so expressed and find the numbers below 129 that can't be so expressed
CO
BEGIN
    INT max number = 324;
    [ 0 : max number ]BOOL is sum; FOR i FROM LWB is sum TO UPB is sum DO is sum[ i ] := FALSE OD;
    INT max square = ENTIER sqrt( 324 );
    [ 0 : max square ]INT  square; FOR i FROM LWB square TO UPB square DO square[ i ] := i * i OD;

    PROC flag sum = ( INT curr sum, sq pos )VOID:
         IF INT next sum = curr sum + square[ sq pos ];
            next sum <= UPB is sum
         THEN
            is sum[ next sum ] := TRUE;
            FOR i FROM sq pos + 1 TO UPB square DO
                flag sum( next sum, i )
            OD
         FI # flag sum # ;

    FOR i FROM LWB square TO UPB square DO
        flag sum( 0, i )
    OD;
    # show the numbers that can't be formed from a sum of distinct squares       #
    # and check 129-324 can be so formed                                         #
    INT unformable := 0;
    FOR i FROM LWB is sum TO UPB is sum DO
        IF NOT is sum[ i ] THEN
            print( ( whole( i, -4 ) ) );
            IF ( unformable +:= 1 ) MOD 12 = 0 THEN print( ( newline ) ) FI;
            IF i > 128 THEN
                print( ( newline, "**** unexpected unformable number: ", whole( i, 0 ), newline ) )
            FI
        FI
    OD
END
