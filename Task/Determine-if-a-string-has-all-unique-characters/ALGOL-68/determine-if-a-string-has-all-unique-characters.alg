BEGIN
    # mode to hold the positions of duplicate characters in a string      #
    MODE DUPLICATE = STRUCT( INT original, first duplicate );
    # finds the first non-unique character in s and returns its position  #
    # and the position of the original character in a DUPLICATE           #
    # if all characters in s are uniue, returns LWB s - 1, UPB s + 1      #
    PROC first duplicate position = ( STRING s )DUPLICATE:
    BEGIN
        BOOL all unique := TRUE;
        INT  o pos      := LWB s - 1;
        INT  d pos      := UPB s + 1;
        FOR i FROM LWB s TO UPB s WHILE all unique DO
            FOR j FROM i + 1 TO UPB s WHILE all unique DO
                IF NOT ( all unique := s[ i ] /= s[ j ] ) THEN
                    o pos := i;
                    d pos := j
                FI
            OD
        OD;
        DUPLICATE( o pos, d pos )
    END # first duplicate position # ;
    # task test cases                                                     #
    []STRING tests = ( "", ".", "abcABC", "XYZ ZYX", "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ" );
    FOR t pos FROM LWB tests TO UPB tests DO
        IF  STRING s    = tests[ t pos ];
            DUPLICATE d = first duplicate position( s );
            print( ( "<<<", s, ">>> (length ", whole( ( UPB s + 1 ) - LWB s, 0 ), "): " ) );
            original OF d < LWB s
        THEN
            print( ( " all characters are unique", newline ) )
        ELSE
            # have at least one duplicate #
            print( ( " first duplicate character: """, s[ original OF d ], """"
                   , " at: ", whole( original OF d, 0 ), " and ", whole( first duplicate OF d, 0 )
                   , newline
                   )
                 )
        FI
    OD
END
