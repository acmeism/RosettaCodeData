FOR sp FROM 0 TO 1 DO
      BOOL done := FALSE;
      FOR x FROM IF sp = 1 THEN 7654321 ELSE 76543211 FI BY -2 TO 0 WHILE NOT done DO
          IF x MOD 3 /= 0 THEN
              STRING s = whole( x, 0 );
              FOR ch FROM sp TO 7 WHILE done := char in string( REPR ( ch + ABS "0" ), NIL, s ) DO SKIP OD;
              IF done THEN
                  INT i := 1;
                  WHILE i * i < x AND done DO
                      IF done :=            ( x MOD ( i + 4 ) /= 0 )   THEN i +:= 4 FI;
                      IF done := ( done AND ( x MOD ( i + 2 ) /= 0 ) ) THEN i +:= 2 FI
                  OD
              FI;
              IF done THEN print( ( whole( sp, 0 ), "..7: ", whole( x, 0 ), newline ) ) FI
          FI
      OD
OD
