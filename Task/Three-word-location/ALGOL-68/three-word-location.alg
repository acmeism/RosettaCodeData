BEGIN # three word location, translation of the Lua sample #

    PROC to word = ( INT w )STRING:
         BEGIN
            STRING word := "W" + whole( w, -5 );
            FOR i FROM LWB word TO UPB word DO IF word[ i ] = " " THEN word[ i ] := "0" FI OD;
            word
         END # to word # ;

    PROC from word = ( STRING word )INT:
         BEGIN
            INT result := 0;
            FOR i FROM LWB word + 1 TO UPB word DO result *:= 10 +:= ( ABS word[ i ] - ABS "0" ) OD;
            result
         END # from number # ;

    INT two to 14 = 2 ^ 14, two to 22 = 2 ^ 22, INT two to 28 = 2 ^ 28;

    PROC to three words = ( REAL lat, lon, REF STRING word1, word2, word3 )VOID:
         BEGIN
            # convert from lat and lon to positive integers #
            INT ilat = ENTIER( lat * 10000 ) +  900000
              , ilon = ENTIER( lon * 10000 ) + 1800000
              ;
            # build 43 bit number comprising 21 bits (lat) and 22 bits (lon) #
            LONG INT latlon = ( LENG ilat * two to 22 ) + LENG ilon;

            # isolate relevant bits #
            INT w1 = SHORTEN ( latlon OVER two to 28 ) MOD ABS 16r8000
              , w2 = SHORTEN ( latlon OVER two to 14 ) MOD ABS 16r4000
              , w3 = SHORTEN ( latlon                  MOD ABS 16r4000 )
              ;
            # convert to word format #
            word1 := to word( w1 );
            word2 := to word( w2 );
            word3 := to word( w3 )

         END # to three words # ;

    PROC from three words = ( STRING word1, word2, word3, REF REAL lat, lon )VOID:
         BEGIN
            INT w1 = from word( word1 )
              , w2 = from word( word2 )
              , w3 = from word( word3 )
              ;
            LONG INT latlon = ( LENG w1 * two to 28 ) + ( LENG w2 * two to 14 ) + LENG w3;
            INT      ilat   = SHORTEN ( latlon OVER two to 22 )
                   , ilon   = SHORTEN ( latlon MOD  ABS 16r400000 )
                   ;
            lat := ( ilat -  900000 ) / 10000;
            lon := ( ilon - 1800000 ) / 10000

         END # from three wordfs # ;

    BEGIN

        PROC show coordinates = ( REAL lat, lon )VOID:
             BEGIN
                print( ( "  latitude = ",  fixed( lat, -8, 4 ) ) );
                print( ( ", longitude = ", fixed( lon, -8, 4 ), newline ) )
             END # show coordinates # ;

        REAL lat = 28.3852, lon = -81.5638;

        print( ( "Starting figures:", newline ) );
        show coordinates( lat, lon );
        print( ( newline ) );

        # latitude and longitude to words #

        STRING w1s := "", w2s := "", w3s := "";

        to three words( lat, lon, w1s, w2s, w3s );

        print( ( "Three word location is:", newline ) );
        print( ( "  ", w1s, " ", w2s, " ", w3s, newline ) );
        print( ( newline ) );

        # words to latitude and longitude #

        REAL rlat := -1, rlon := -1;
        from three words( w1s, w2s, w3s, rlat, rlon );

        print( ( "After reversing the procedure:", newline ) );
        show coordinates( rlat, rlon );
        IF rlat /= lat OR rlon /= lon THEN print( ( "**** not as expected", newline ) ) FI
    END
END
