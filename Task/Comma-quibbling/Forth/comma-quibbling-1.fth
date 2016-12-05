\ string primitives operate on addresses passed on the stack
: C+!      ( n addr -- )        dup >R  C@ +  R> C! ;                     \ increment a byte at addr by n
: APPEND   ( addr1 n addr2 -- ) 2DUP 2>R  COUNT +  SWAP MOVE 2R> C+! ;    \ append u bytes at addr1 to addr2
: PLACE    ( addr1 n addr2 -- )  2DUP 2>R  1+  SWAP  MOVE  2R> C! ;       \ copy n bytes at addr to addr2
: ,'       ( -- )               [CHAR] ' WORD  c@ 1+ ALLOT ALIGN ;        \ Parse input stream until ' and write into next
                                                                          \ available memory

\ use ,' to create some counted string literals with mnemonic names
create '"{}"' ( -- addr) ,' "{}"'                                         \ counted strings return the address of the 1st byte
create '"{'   ( -- addr) ,' "{'
create '}"'   ( -- addr) ,' }"'
create ','    ( -- addr) ,' , '
create 'and'  ( -- addr) ,'  and '
create "]     ( -- addr) ,' "]'

create null$ ( -- addr)  0 ,

HEX
\ build a string stack/array to hold input strings
100 constant ss-width                                                     \ string stack width
variable $DEPTH                                                           \ the string stack pointer

create $stack ( -- addr) 20 ss-width * allot

DECIMAL
: new:   ( -- )    1 $DEPTH +! ;                                          \ incr. string stack pointer
: ]stk$  ( ndx -- addr) ss-width * $stack + ;                             \ calc string stack element address from ndx
: TOP$   ( -- addr) $DEPTH @ ]stk$ ;                                      \ returns address of the top string on string stack
: collapse ( -- )     $DEPTH off ;                                        \ reset string stack pointer

\ used primitives to build counted string functions
: move$    ( $1 $2 -- ) >r COUNT R> PLACE ;                               \ copy $1 to $2
: push$    ( $ -- )     new: top$ move$ ;                                 \ push $ onto string stack
: +$       ( $1 $2 --  top$ ) swap push$ count TOP$ APPEND top$ ;         \ concatentate $2 to $1, Return result in TOP$
: LEN      ( $1 -- length)  c@ ;                                          \ char fetch the first byte returns the string length
: compare$ ( $1 $2 -- -n:0:n )  count rot count compare ;                 \ compare is an ANS Forth word. returns 0 if $1=$2
: =$       ( $1 $2 -- flag )    compare$ 0= ;
: [""]     ( -- )  null$  push$ ;                                         \ put a null string on the string stack

: ["                                                                      \ collects input strings onto string stack
           COLLAPSE
           begin
              bl word dup "] =$ not                                       \ parse input stream and terminate at "]
           while
              push$
           repeat
           drop
           $DEPTH @ 0= if [""] then ;                                      \ minimally leave a null string on the string stack


: ]stk$+   ( dest$ n -- top$)  ]stk$  +$  ;                                \ concatenate  n ]stk$ to DEST$

: writeln  ( $ -- )  cr count type collapse ;                              \ print string on new line and collapse string stack

\ write the solution with the new words
: 1-input    ( -- )
            1 ]stk$ LEN 0=                                                 \ check for empty string length
            if
                 '"{}"' writeln                                            \ return the null string output
            else
                 '"{'  push$                                               \ create a new string beginning with '{'
                 TOP$  1 ]stk$+ '}"' +$  writeln                           \ concatenate the pieces for 1 input

            then  ;

: 2-inputs ( -- )
           '"{'  push$
           TOP$  1 ]stk$+  'and' +$   2 ]stk$+  '}"' +$ writeln ;

: 3+inputs ( -- )
           $DEPTH @ dup >R                                                \ save copy of the number of inputs on the return stack
           '"{'  push$
           ( n) 1- 1                                                      \ loop indices for 1 to 2nd last string
           DO   TOP$  I ]stk$+  ',' +$   LOOP                             \ create all but the last 2 strings in a loop with comma
           ( -- top$) R@ 1- ]stk$+  'and' +$                              \ concatenate the 2nd last string to Top$ + 'and'
           R> ]stk$+  '}"' +$ writeln                                     \ use the copy of $DEPTH to get the final string index
           2drop ;                                                        \ clean the parameter stack

: quibble ( -- )
           $DEPTH @
           case
             1 of  1-input    endof
             2 of  2-inputs   endof
                   3+inputs                                               \ default case
           endcase ;


\ interpret this test code after including the above code
[""] QUIBBLE
[" "] QUIBBLE
[" ABC "] QUIBBLE
[" ABC DEF "] QUIBBLE
[" ABC DEF GHI BROWN FOX "] QUIBBLE
