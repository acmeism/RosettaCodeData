BEGIN
    # returns TRUE if cusip is a valid CUSIP code #
    OP ISCUSIP = ( STRING cusip )BOOL:
       IF ( UPB cusip - LWB cusip ) /= 8
       THEN
           # code is wrong length #
           FALSE
       ELSE
           # string is 9 characters long - check it is valid #
           STRING cusip digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ*@#"[ AT 0 ];
           INT check digit := 0;
           IF NOT char in string( cusip[ UPB cusip ], check digit, cusip digits )
           THEN
               # invalid check digit #
               FALSE
           ELSE
               # OK so far compare the calculated check sum to the supplied one #
               INT sum := 0;
               INT c pos := LWB cusip - 1;
               FOR i TO 8 DO
                   INT digit := 0;
                   IF NOT char in string( cusip[ i + c pos ], digit, cusip digits )
                   THEN
                       # invalid digit #
                       digit := -999
                   FI;
                   IF NOT ODD i
                   THEN
                       # even digit #
                       digit *:= 2
                   FI;
                   sum +:= ( digit OVER 10 ) + ( digit MOD 10 )
               OD;
               ( 10 - ( sum MOD 10 ) ) MOD 10 = check digit
           FI
       FI ; # ISCUSIP #

    # task test cases #

    PROC test cusip = ( STRING cusip )VOID:
        print( ( cusip, IF ISCUSIP cusip THEN " valid" ELSE " invalid" FI, newline ) );

    test cusip( "037833100" );
    test cusip( "17275R102" );
    test cusip( "38259P508" );
    test cusip( "594918104" );
    test cusip( "68389X106" );
    test cusip( "68389X105" )
END
