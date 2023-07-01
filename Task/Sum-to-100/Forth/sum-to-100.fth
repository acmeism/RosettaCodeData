CREATE *OPS CHAR + C, CHAR - C, CHAR # C,
CREATE 0OPS CHAR - C, CHAR # C,
CREATE BUFF 43 C, 43 CHARS ALLOT
CREATE PTR CELL ALLOT
CREATE LIMITS 2 C, 3 C, 3 C, 3 C, 3 C, 3 C, 3 C, 3 C, 3 C,
CREATE INDX   0 C, 0 C, 0 C, 0 C, 0 C, 0 C, 0 C, 0 C, 0 C,
CREATE OPS 0OPS , *OPS , *OPS , *OPS , *OPS , *OPS , *OPS , *OPS , *OPS ,
: B0   BUFF 1+ dup  PTR !  43 blank ;
: B, ( c --)  PTR @ C!  1 PTR +! ;
CREATE STATS 123456790 ALLOT  STATS 123456790 ERASE

: inc ( c-addr c-lim u -- t|f)
   1- tuck + >r swap dup rot + ( addr a-addr) ( R: l-addr)
   BEGIN dup C@ 1+ dup r@ C@ =
     IF drop 2dup =
       IF 2drop FALSE rdrop EXIT   \ no inc, contents invalid
       ELSE 0 over C! 1-  r> 1- >r  \ reset and carry
       THEN
     ELSE swap C! drop TRUE rdrop EXIT
     THEN
   AGAIN ;
: INDX+   INDX LIMITS 9 inc 0= ;
: SYNTH   B0  [CHAR] 0 B,  9 0 DO
     INDX I + C@  OPS I CELLS + @ + C@
     dup  [CHAR] # <> IF BL B, B, BL B, ELSE drop THEN
     I [CHAR] 1 + B,
   LOOP  BUFF COUNT ;
: .MOST   cr ." Sum that has the maximum number of solutions" cr 4 spaces
   STATS 0  STATS 1+ 123456789 bounds DO
     dup I c@ <  IF drop drop I I c@ THEN
   LOOP  swap STATS - . ." has " . ." solutions" ;
: .CANT   cr ." Lowest positive sum that can't be expressed" cr 4 spaces
   STATS 1+ ( 0 not positive)  BEGIN dup c@ WHILE 1+ REPEAT  STATS - . ;
: .BEST   cr ." Ten highest numbers that can be expressed" cr 4 spaces
   0 >r  [ STATS 123456789 + ]L
   BEGIN  r@ 10 <  over STATS >= and
   WHILE  dup c@ IF dup STATS - .  r> 1+ >r THEN  1-
   REPEAT  r> drop ;
: .   0 <# #S #> TYPE ;
: .INFX   cr 4 spaces  9 0 DO
     INDX I + C@  OPS I cells + @ + C@
     dup  [char] # <> IF emit ELSE drop THEN  I 1+ .
   LOOP ;
: REPORT ( n)   dup 100 =  IF .INFX THEN
   dup 0> IF STATS + dup  c@ 1+  swap c! ELSE drop THEN ;
: >NUM   0. bl word count >number 2drop d>s ;
: #   10 * + ;   \ numeric concatenation
: +    >NUM + ;  \ infix +
: -    >NUM - ;  \ infix -
: .SOLUTIONS   cr ." Solutions that sum to 100:"
   BEGIN SYNTH EVALUATE REPORT INDX+ UNTIL ;
: SUM100   .SOLUTIONS .MOST .CANT .BEST cr ;
