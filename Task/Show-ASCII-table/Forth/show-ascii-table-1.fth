DECIMAL
: ###: ( c -- ) 3 .R ." : " ;

: .CHAR  ( c -- )
        DUP
        CASE
         BL OF  ###: ." spc"  ENDOF
        127 OF  ###: ." del"  ENDOF
            DUP ###: EMIT  2 SPACES
        ENDCASE
        3 SPACES ;

: .ROW ( n2 n1 -- )
       CR DO   I .CHAR   16 +LOOP ;

: ASCII.TABLE ( -- )
        16 0 DO   113 I +   32 I +  .ROW     LOOP ;
