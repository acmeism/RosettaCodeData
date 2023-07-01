BEGIN
    # returns the longest common substring of s and t #
    PROC longest common substring = ( STRING s, t )STRING:
         BEGIN
            STRING s1       = s[ @ 1 ]; # normalise bounds to 1 : ... #
            STRING s2       = t[ @ 1 ];
            STRING result  := "";
            INT result len := 0;
            FOR i TO UPB s1 DO
                FOR j TO UPB s2 DO
                    IF s1[ i ] = s2[ j ] THEN
                        INT k := 1;
                        WHILE INT ik = i + k;
                              INT jk = j + k;
                              IF ik > UPB s1 OR jk > UPB s2
                              THEN FALSE
                              ELSE s1[ ik ] = s2[ jk ]
                              FI
                        DO
                            k +:= 1
                        OD;
                        IF k > result len THEN
                            # found a longer substring #
                            result len := k;
                            result     := s1[ i : ( i + k ) - 1 ]
                        FI
                    FI
                OD
            OD;
            result
         END # longest common substring # ;

    # task test case #
    print( ( longest common substring( "thisisatest", "testing123testing" ), newline ) )
END
