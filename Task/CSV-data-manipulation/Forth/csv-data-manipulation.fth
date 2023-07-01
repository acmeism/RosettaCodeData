\ csvsum.fs     Add a new column named SUM that contain sums from rows of CommaSeparatedValues
\ USAGE:
\       gforth-fast csvsum.fs -e "stdout stdin csvsum bye" <input.csv >output.csv

        CHAR ,  CONSTANT SEPARATOR
        3       CONSTANT DECIMALS
        1E1 DECIMALS S>D D>F F** FCONSTANT FSCALE

: colsum        ( ca u -- F: -- sum ;return SUM from CSV-string )
        0E0 OVER SWAP BOUNDS
        ?DO     ( a )
                I C@ SEPARATOR =
                IF      ( a )
                        I TUCK OVER - >FLOAT  IF F+ THEN
                        1+
                THEN
        LOOP    DROP
;
: f>string      ( -- ca u F: x -- )
        FSCALE F*
        F>D TUCK DABS <# DECIMALS 0 DO # LOOP [CHAR] . HOLD #S ROT SIGN #>
;
: rowC!+        ( offs char -- u+1  ;store CHAR at here+OFFS,increment offset )
        OVER HERE + C! 1+
;
: row$!+        ( offs ca u -- offs+u ;store STRING at here+OFFS,update offset )
        ROT 2DUP + >R HERE + SWAP MOVE R>
;
\ If run program with '-m 4G'option, we have practically 4G to store a row
: csvsum        ( fo fi --  ;write into FILEID-OUTPUT processed input from FILEID-INPUT )
        2DUP
        HERE UNUSED ROT READ-LINE THROW
        IF      ( fo fi fo u )
                HERE SWAP               ( fo fi fo ca u )
                SEPARATOR rowC!+
                s\" SUM" row$!+         ( fo fi fo ca u' )
                ROT WRITE-LINE THROW
                BEGIN   ( fo fi )
                        2DUP HERE UNUSED ROT READ-LINE THROW
                WHILE   ( fo fi fo u )
                        HERE SWAP                       ( fo fi fo ca u )
                        SEPARATOR rowC!+
                        HERE OVER colsum f>string       ( fo fi fo ca u ca' u' )
                        row$!+                          ( fo fi fo ca u'+u )
                        ROT WRITE-LINE THROW
                REPEAT
        THEN
        2DROP 2DROP
;
