BEGIN # biorythms                                                            #

    # code from the Day of the week of Christmas and New Year task           #
    []STRING day name =
        []STRING( "SAT", "SUN", "MON", "TUE", "WED", "THU", "FRI" )[ AT 0 ];
    PROC day of week = ( INT y, m, d )INT:
         BEGIN
            INT mm := m;
            INT yy := y;
            IF mm <= 2 THEN
                mm +:= 12;
                yy -:= 1
            FI;
            INT j = yy OVER 100;
            INT k = yy MOD  100;
            ( d + ( ( mm + 1 ) * 26 ) OVER 10 + k + k OVER 4 + j OVER 4 + 5 * j ) MOD 7
         END # day of week # ;
    # end code from the Day of the week of Christmas and New Year task       #
    # code from the days between dates task                                  #
    PROC gregorian = ( INT y, m, d )INT:
         BEGIN
             INT n = ( m + 9 ) - ( ( ( m + 9 ) OVER 12 ) * 12 );
             INT w = y - ( n OVER 10 );
             ( 365 * w ) + ( w OVER 4 ) - ( w OVER 100 ) + ( w OVER 400 )
                         + ( ( ( n * 306 ) + 5 ) OVER 10 ) + ( d - 1 )
         END # gregorian # ;
    # end code from the days between dates task                              #

    BEGIN # main routine - translated from the Fortran sample's main program #
        PROC double line = VOID: print( ( "=" * 75, newline ) );
        PROC in range = ( REAL v, INT low, high )INT:
             IF v < low THEN low ELIF v > high THEN high ELSE ENTIER v FI;

        REAL pi2 = pi * 2;

        INT byear, bmon, bday, tyear, tmon, tday, nday;
        print( ( "ENTER YOUR BIRTHDAY YYYY MM DD: " ) );
        read( ( byear, bmon, bday ) );
        print( ( "ENTER START DATE    YYYY MM DD: " ) );
        read( ( tyear, tmon, tday ) );
        print( ( "ENTER NUMBER OF DAYS TO PLOT  : " ) );
        read( ( nday ) );

        INT jd0  = gregorian( tyear,    1,    1 );
        INT jd1  = gregorian( byear, bmon, bday );
        INT jd2 := gregorian( tyear, tmon, tday );
        INT dob  = day of week( byear, bmon, bday );
        INT dow := day of week( tyear, tmon, tday );

        double line;
        print( ( "YOU WERE BORN ON A (", day name[ dob MOD 7 ], ") YOU WERE " ) );
        print( ( whole( jd2 - jd1, 0 ), " DAYS OLD ON THE START DATE.", newline ) );
        print( ( "-1", 31 * " ", "0", 30 * " ", "+1     DOY", newline ) );
        TO nday DO
           INT dif = jd2 - jd1;
           INT phy = in range( 3.3e1+3.2e1*sin( pi2 * dif / 2.3e1 ), 1, 65 );
           INT emd = in range( 3.3e1+3.2e1*sin( pi2 * dif / 2.8e1 ), 1, 65 );
           INT men = in range( 3.3e1+3.2e1*sin( pi2 * dif / 3.3e1 ), 1, 65 );
           STRING g row := 65 * IF day name[ dow ] = "SUN" THEN "." ELSE " " FI;
           g row[   1 ] := "|";
           g row[  17 ] := ":";
           g row[  33 ] := "|";
           g row[  49 ] := ":";
           g row[  65 ] := "|";
           g row[ phy ] := "P";
           g row[ emd ] := "E";
           g row[ men ] := "M";
           IF phy = emd OR phy = men THEN g row[ phy ] := "*" FI;
           IF emd = men THEN g row[ emd ] := "*" FI;
           print( ( " ", g row, " ", day name[ dow ], " ", whole( jd2 - jd0 + 1, -3 ), newline ) );
           jd2 +:= 1;
           dow +:= 1 MODAB 7
        OD;
        double line
    END
END
