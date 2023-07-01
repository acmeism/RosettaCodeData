: :macro ( "name <char> ccc<char>" -- )
  : [CHAR] ; PARSE  POSTPONE SLITERAL  POSTPONE EVALUATE
  POSTPONE ; IMMEDIATE
;

:macro times   0 do ;

: test  8 times ." spam " loop ;

see test
: test
  8 0
  DO     .\" spam "
  LOOP
  ; ok
