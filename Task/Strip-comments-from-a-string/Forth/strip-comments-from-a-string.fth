\ Rosetta Code Strip Comment

: LASTCHAR ( addr len -- addr len c) 2DUP + C@ ;
: COMMENT? ( char -- ? )  S" #;"  ROT SCAN NIP ;    \ test char for "#;"
: -LEADING ( addr len -- addr' len')  BL SKIP ;     \ remove leading space characters

: -COMMENT   ( addr len -- addr len') \ removes # or ; comments
            1-
            BEGIN
              LASTCHAR COMMENT? 0=
            WHILE                     \ while not a comment char...
                1-                    \ reduce length by 1
            REPEAT
            1-  ;                     \ remove 1 more (the comment char)

: -TRAILING  ( adr len -- addr len')   \ remove trailing spaces
             1-
             BEGIN
               LASTCHAR BL =
             WHILE                    \ while lastchar = blank
               1-                     \ reduce length by 1
             REPEAT
             1+ ;

: COMMENT-STRIP ( addr len -- addr 'len) -LEADING -COMMENT -TRAILING  ;
