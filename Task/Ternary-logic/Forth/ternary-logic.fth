1 constant maybe

: tnot dup maybe <> if invert then ;
: tand and ;
: tor or ;
: tequiv 2dup and rot tnot rot tnot and or ;
: timply tnot tor ;
: txor tequiv tnot ;

: t. C" TF?" 2 + + c@ emit ;

: table2. ( xt -- )
  cr ."     T F ?"
  cr ."   --------"
  2 true DO
    cr I t.  ."  | "
    2 true DO
      dup I J rot execute t. ."  "
    LOOP
  LOOP DROP ;

: table1. ( xt -- )
  2 true DO
    CR I t. ."  | "
    dup I swap execute t.
  LOOP DROP ;

CR ." [NOT]" ' tnot table1. CR
CR ." [AND]" ' tand table2. CR
CR ." [OR]" ' tor table2. CR
CR ." [XOR]" ' txor table2. CR
CR ." [IMPLY]" ' timply table2. CR
CR ." [EQUIV]" ' tequiv table2. CR
