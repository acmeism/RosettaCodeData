BEGIN # wasteful, equidigital and frugal numbers - translation of the EasyLang sample #

  INT wasteful = 1, equidigital = 2, frugal = 3;
  []STRING title = ( "wasteful", "equidigital", "frugal" );

  [ 1 : 2 000 000 ]INT d; FOR i TO UPB d DO d[ i ] := 0 OD;
  PROC classify = VOID: BEGIN
     INT ndig := 1; INT n10 := 10;
     d[ 1 ] := 1;
     FOR i FROM 2 TO UPB d DO
        IF i = n10 THEN ndig +:= 1; n10 *:= 10 FI;
        IF   d[ i ] = 0
        THEN d[ i ] := ndig;
             FOR j FROM i + i BY i TO UPB d DO
                INT h := j;
                INT e := 0;
                INT edig := 1; INT e10 := 10;
                WHILE h MOD i = 0 DO
                   h  := h OVER i;
                   e +:= 1;
                   IF e = e10 THEN edig +:= 1; e10 *:= 10 FI
                OD;
                h := 0;
                IF e > 1 THEN h := edig FI;
                d[ j ] +:= ndig + h
             OD
        FI
     OD;
     ndig := 1; n10 := 10;
     FOR i TO UPB d DO
        IF i = n10 THEN ndig +:= 1; n10 *:= 10 FI;
        d[ i ]  := IF   d[ i ] > ndig
                   THEN wasteful
                   ELIF d[ i ] = ndig
                   THEN equidigital
                   ELSE frugal
                   FI
     OD
  END # classify # ;
  PROC show = ( INT t )VOID: BEGIN
     INT i := 1, count := 0;
     print( ( "First 50 ", title[ t ], " numbers:", newline ) );
     WHILE IF   d[ i ] = t
           THEN IF   ( count +:= 1 ) <= 50
                THEN print( ( whole( i, -5 ) ) );
                     IF count MOD 10 = 0 THEN print( ( newline ) ) FI
                FI
           FI;
           count < 10000
     DO i +:= 1 OD;
     print( ( newline, "10 000th ", title[ t ], " number: ", whole( i, 0 ), newline, newline ) )
  END # show # ;

  classify;
  show( wasteful    );
  show( equidigital );
  show( frugal      );
  print( ( "Under 1 000 000, the counts are:", newline ) );
  [ wasteful : frugal ]INT sum := ( 0, 0, 0 );
  FOR i TO 999 999 DO sum[ d[ i ] ] +:= 1 OD;
  FOR h FROM LWB sum TO UPB sum DO
      print( ( "    ", title[ h ], ": ", whole( sum[ h ], 0 ), newline ) )
  OD
END
