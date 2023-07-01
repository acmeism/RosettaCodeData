\ linked list of strings creators
: ,"       ( -- )  [CHAR] " WORD  c@ 1+ ALLOT  ;             \ Parse input stream until " and write into next available memory
: [[       ( -- )  0 C, ;                                    \ begin a list. write a 0 into next memory byte (null string)
: ]]       ( -- )  [[ ;                                      \ end list with same null string

: nth      ( n list -- addr) swap 0 do count + loop ;        \ return address of the Nth item in a list

: items    ( list -- n )                                     \ return the number of items in a list
          0 >R
          BEGIN
            COUNT + DUP
            R> 1+ >R
          0= UNTIL
          DROP
          R> 1- ;

: compare$ ( $1 $2 -- -n|0|n )  count rot count compare ;    \ compare is an ANS Forth word. returns 0 if $1=$2

: compare[]   ( list n1 n2 -- flag)                          \ compare items n1 and n2 in list
            ROT dup >R nth ( -- $1)
            swap r> nth    ( -- $1 $2)
            compare$ ;

\ create our lexical operators
: LEX=     ( list -- flag)
           0                                                 \ place holder for the flag
           over items 1
           DO
              over I  I 1+ compare[] +                       \ we sum the comparison results on the stack
           LOOP
           nip 0= ;

: LEX<     ( list -- flag)
           0                                                 \ place holder for the flag
           over items 1
           DO
              over I  I 1+ compare[] 0< NOT +
           LOOP
           nip 0= ;

\ make some lists
create strings  [[ ," ENTRY 4" ," ENTRY 3" ," ENTRY 2" ," ENTRY 1" ]]
create strings2 [[ ," the same" ," the same" ," the same" ]]
create strings3 [[ ," AAA" ," BBB" ," CCC" ," DDD" ]]
