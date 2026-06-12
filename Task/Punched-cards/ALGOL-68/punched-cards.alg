BEGIN # show some "punched cards" with Hollerith coded characters            #

    # punch codes, each character can have multiple punches, the rows are    #
    # numbered 12, 11, 0, 1, ..., 9 - these are encoded as hex-digits:       #
    #           c,  b, a, 1, ..., 9 so a encodes 0 so we can distinguish     #
    # between no punch and punching in the 0 row                             #
    [ 0 : 255 ]BITS h code;    # ASCII but only 7-bit characters are defined #
    BEGIN
        PROC code of  = ( INT c )INT: IF c = 0 THEN 10 ELSE c FI;
        PROC set code = ( CHAR c, BITS h )VOID: h code[ ABS c ] := h;
        FOR c FROM LWB h code TO UPB h code DO h code[ c ] := 16r0 OD;
        # digits                                                             #
        FOR c FROM 0 TO 9 DO h code[ ABS "0" + c ] := BIN code of( c ) OD;
        # letters                                                            #
        FOR c FROM ABS "A" TO ABS "I" DO h code[ c ] :=  16rc0 OR BIN ( c - ABS "A" + 1 ) OD;
        FOR c FROM ABS "J" TO ABS "R" DO h code[ c ] :=  16rb0 OR BIN ( c - ABS "J" + 1 ) OD;
        FOR c FROM ABS "S" TO ABS "Z" DO h code[ c ] :=  16ra0 OR BIN ( c - ABS "S" + 2 ) OD;
        FOR c FROM ABS "a" TO ABS "i" DO h code[ c ] := 16rca0 OR BIN ( c - ABS "a" + 1 ) OD;
        FOR c FROM ABS "j" TO ABS "r" DO h code[ c ] := 16rcb0 OR BIN ( c - ABS "j" + 1 ) OD;
        FOR c FROM ABS "s" TO ABS "z" DO h code[ c ] := 16rba0 OR BIN ( c - ABS "s" + 2 ) OD;
        # others                                                             #
        set code( "&",   16rc ); set code( "-",   16rb );
        set code( "[", 16r28c ); set code( ".", 16r38c ); set code( "<", 16r48c );
        set code( "(", 16r58c ); set code( "+", 16r68c ); set code( "!", 16r78c );
        set code( "]", 16r28b ); set code( "$", 16r38b ); set code( "*", 16r48b );
        set code( ")", 16r58b ); set code( ";", 16r68b ); set code( "^", 16r78b );
        set code( "\", 16r28a ); set code( ",", 16r38a ); set code( "%", 16r48a );
        set code( "_", 16r58a ); set code( ">", 16r68a ); set code( "?", 16r78a );
        set code( "/",  16r1a ); set code( "`",  16r18 );
        set code( ":",  16r28 ); set code( "#",  16r38 ); set code( "@",  16r48 );
        set code( "'",  16r58 ); set code( "=",  16r68 ); set code( """", 16r78 );
        set code( "|",  16rcb ); set code( "{",  16rca ); set code( "}",  16rba )
    END;

    # returns a "card" punched with text in Hollerith code                   #
    PROC make card = ( STRING text )[,]CHAR:
         BEGIN
            # initialise the card to unpunched                               #
            [ 1 : 16, 1 : 84 ]CHAR card;
            STRING unpunched = "-   0123456789 -";
            FOR r FROM 1 LWB card TO 1 UPB card DO
                card[ r, 2 LWB card     ] := "|";
                card[ r, 2 LWB card + 1 ] := " ";
                FOR c FROM 2 LWB card + 2 TO 2 UPB card - 2 DO
                    card[ r, c ] := unpunched[ r ]
                OD;
                card[ r, 2 UPB card - 1 ] := " ";
                card[ r, 2 UPB card     ] := "|"
            OD;
            card[ 1 LWB card, 2 LWB card     ] := "/";
            card[ 1 LWB card, 2 LWB card + 1 ] := "-";
            card[ 1 LWB card, 2 UPB card - 1 ] := "-";
            card[ 1 LWB card, 2 UPB card     ] := "+";
            card[ 1 UPB card, 2 LWB card     ] := "+";
            card[ 1 UPB card, 2 LWB card + 1 ] := "-";
            card[ 1 UPB card, 2 UPB card - 1 ] := "-";
            card[ 1 UPB card, 2 UPB card     ] := "+";
            # punch the supplied text                                        #
            CHAR punched = REPR 178;
            INT c pos := 2 LWB card + 2;
            INT c max := 2 UPB card - 2;
            FOR s pos FROM LWB text TO UPB text WHILE c pos < c max DO
                CHAR to punch = text[ s pos ];
                card[ 1 LWB card + 1, c pos ] := to punch;
                INT punches := ABS h code[ ABS to punch ];
                WHILE punches > 0 DO
                    INT r = punches MOD 16;
                    IF   r > 9 THEN
                        card[ 1 LWB card + 2 + 12 - r, c pos ] := punched
                    ELSE
                        card[ 1 LWB card + 4      + r, c pos ] := punched
                    FI;
                    punches OVERAB 16
                OD;
                c pos +:= 1
            OD;
            card
         END # make card # ;

    PROC show card = ( [,]CHAR card )VOID:
         FOR r FROM 1 LWB card TO 1 UPB card DO
             FOR c FROM 2 LWB card TO 2 UPB card DO print( ( card[ r, c ] ) ) OD;
             print( ( newline ) )
         OD # show card # ;

    show card( make card( "&-0123456789ABCDEFGHIJKLMNOPQR/STUVWXYZ:#@'=""[.<(+|]$*);^\,%_>?" ) );
    print( ( newline ) );
    show card( make card( "print( ( ""Hello, World!"", newline ) )"                          ) )

END
