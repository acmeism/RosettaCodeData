\ Rosetta Code Strip Comment

: LASTCHAR ( addr len -- addr len c) 2DUP + 1- C@ ;

: COMMENT? ( char -- ? )  S" #;"  ROT SCAN NIP ; \ is char '#' or ';'

: -COMMENT   ( addr len -- addr len') \ removes # or ; comments
            BEGIN
              LASTCHAR COMMENT? 0=
             WHILE                    \ while not a comment char...
                1-                    \ reduce length by 1
            REPEAT
            1-  ;                     \ remove 1 more (the comment char)

\ -TRAILING is resident in desktop Forth systems like Swift Forth
\ shown here for demonstration
: -TRAILING  ( adr len -- adr len')    \ remove trailing spaces
             BEGIN
               LASTCHAR BL =
             WHILE                     \ while lastchar = blank char
               1-                      \ reduce length by 1
             REPEAT  ;

: COMMENT-STRIP ( addr len -- addr 'len)  -COMMENT  -TRAILING ;
