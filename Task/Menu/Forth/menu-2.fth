\ Rosetta Menu task with Simple lists in Forth

: STRING, ( caddr len -- ) HERE  OVER CHAR+  ALLOT  PLACE ;
: "       ( -- ) [CHAR] " PARSE  STRING, ;

: {       ( -- ) ALIGN 0 C, ;
: }       ( -- ) { ;

: {NEXT} ( str -- next_str)  COUNT + ;
: {NTH}  ( n array_addr -- str)  SWAP 0 DO {NEXT} LOOP ;

: {LEN}  ( array_addr -- )  \ count strings in a list
          0 >R                      \ Counter on Rstack
          {NEXT}                    \ skip 1st empty string
          BEGIN
             {NEXT} DUP C@          \ Fetch length byte
          WHILE                     \ While true
             R> 1+ >R               \ Inc. counter
          REPEAT
          DROP
          R> ;                      \ return counter to data stack

: {TYPE}    ( $ -- ) COUNT TYPE ;
: '"'    ( -- )   [CHAR] " EMIT ;
: {""}   ( $ -- )  '"' SPACE {TYPE} '"' SPACE ;
: }PRINT ( n array -- ) {NTH} {TYPE} ;

\ ===== TASK BEGINS =====
CREATE GOODLIST
       { " fee fie"
         " huff and puff"
         " mirror mirror"
         " tick tock" }

CREATE NIL  {   }

CHAR 1 CONSTANT '1'
CHAR 4 CONSTANT '4'
CHAR 0 CONSTANT '0'

: BETWEEN ( n low hi -- ?)  1+ WITHIN ;

: .MENULN ( n -- n) DUP '0' + EMIT SPACE OVER }PRINT ;

: MENU    ( list -- string )
       DUP {LEN} 0=
       IF
           DROP NIL
       ELSE
          BEGIN
             CR
             CR 1 .MENULN
             CR 2 .MENULN
             CR 3 .MENULN
             CR 4 .MENULN
             CR ." Choice: " KEY DUP EMIT
             DUP '1' '4' BETWEEN
         0= WHILE
              DROP
          REPEAT
         [CHAR] 0 -
         CR SWAP {NTH}
       THEN
;
