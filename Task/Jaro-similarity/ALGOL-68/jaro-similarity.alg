BEGIN # Jaro distance - translated from the EasyLang sample                  #
    PROC jaro distance = ( STRING s1, s2 )REAL: BEGIN
         INT len s1   = ( UPB s1 - LWB s1 ) + 1;
         INT len s2   = ( UPB s2 - LWB s2 ) + 1;
         INT matchstd = IF len s1 > len s2 THEN len s1 ELSE len s2 FI OVER 2 - 1;
         INT m := 0, p := 0;
         FOR i1 FROM LWB s1 TO UPB s1 DO
             FOR i2 FROM LWB s2 TO UPB s2 DO
                 IF s1[ i1 ] = s2[ i2 ] THEN
                     IF ABS ( i2 - i1 ) <= matchstd THEN
                         m +:= 1;
                         IF i2 = i1 THEN
                             p +:= 1
                         FI
                     FI
                 FI
             OD
         OD;
         INT t = ( m - p ) OVER 2;
         1 / 3 * ( m / len s1 + m / len s2 + ( m - t ) / m )
    END ;
    PROC print jaro distance = ( STRING s1, s2 )VOID:
         print( ( s1, " :: ", s2, " -> ", fixed( jaro distance( s1, s2 ), -6, 2 ), newline ) );

    print jaro distance( "MARTHA",    "MARHTA"     );
    print jaro distance( "DIXON",     "DICKSONX"   );
    print jaro distance( "JELLYFISH", "SMELLYFISH" )

END
