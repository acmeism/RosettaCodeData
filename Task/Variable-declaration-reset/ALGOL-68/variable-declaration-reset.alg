BEGIN
    []INT s = ( 1, 2, 2, 3, 4, 4, 5 );
    FOR i FROM LWB s TO UPB s DO
        INT curr := s[ i ], prev;
        IF IF i > LWB s THEN curr = prev ELSE FALSE FI THEN
            print( ( i, newline ) )
        FI;
        prev := curr
    OD
END
