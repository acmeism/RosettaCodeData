BEGIN # find the last element after repeatedly adding the sum #
      # of the two smallest elements and removing them #
    [ 1 : 9 ]INT a := ( 6, 81, 243, 14, 25, 49, 123, 69, 11 );
    INT a count := UPB a;
    WHILE a count > 1 DO
        print( ( "List:" ) );FOR i TO a count DO print( ( " ", whole( a[ i ], 0 ) ) ) OD;
        INT s1pos, s2pos;
        IF a[ 1 ] < a[ 2 ]
        THEN s1pos := 1; s2pos := 2
        ELSE s1pos := 2; s2pos := 1
        FI;
        FOR i FROM 3 TO a count DO
            IF   a[ i ] < a[ s1pos ] THEN s2pos := s1pos; s1pos := i
            ELIF a[ i ] < a[ s2pos ] THEN s2pos := i
            FI
        OD;
        INT sum = a[ s1pos ] + a[ s2pos ];
        print( ( "; two smallest: " , whole( a[ s1pos ], 0 ), " @ ", whole( s1pos, 0 )
               , " and ",             whole( a[ s2pos ], 0 ), " @ ", whole( s2pos, 0 )
               , "; sum = ", whole( sum, 0 )
               , newline
               )
             );
        INT m pos := 0;
        FOR i TO a count DO
            IF i /= s1pos AND i /= s2pos THEN a[ m pos +:= 1 ] := a[ i ] FI
        OD;
        a[ m pos + 1 ] := sum;
        a count -:= 1
    OD;
    print( ( "Last item is ", whole( a[ 1 ], 0 ), ".", newline ) )
END
