\ short-circuit conditional syntax, from Wil Baden
:  COND  0 ; immediate
: THENS  BEGIN dup WHILE postpone THEN REPEAT DROP ; immediate
:  ORIF  s" ?DUP 0= IF"  evaluate ; immediate
: ANDIF  s" DUP IF DROP" evaluate ; immediate

: .bool IF ." true " ELSE ." false" THEN ;
: A  ." A=" dup .bool ;
: B  ." B=" dup .bool ;

: test
  1 -1 DO 1 -1 DO
    CR I A drop space J B drop space
    ." : ANDIF " COND I A ANDIF drop J B    IF ."  (BOTH)"    THENS
    ." , ORIF "  COND I A  ORIF drop J B 0= IF ."  (NEITHER)" THENS
  LOOP LOOP ;

\ a more typical example
: alnum? ( char -- ? )
  COND dup lower? ORIF dup upper? ORIF dup digit? THENS nip ;
