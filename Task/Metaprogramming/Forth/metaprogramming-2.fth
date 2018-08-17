 : CHARSET    [CHAR] ~  [CHAR] ! DO  I EMIT LOOP ;

: >DIGIT ( n -- c) DUP 9 > IF  7 +  THEN [CHAR] 0 + ;

: -TRAILING  ( adr len -- adr len')  \ remove trailing blanks (spaces)
             BEGIN
                2DUP + 1- C@ BL =    \ test if last char = blank
             WHILE
                1-                   \ dec. length
             REPEAT ;
