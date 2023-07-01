: CASE:  ( <name>)   CREATE   ;

\ lookup execution token and compile
: |      ( <name> )  '  compile,  ;

: ;CASE   ( n -- )  DOES>  OVER + + @ EXECUTE ;

 : FOO   ." FOO" ;
 : BAR   ." BAR" ;
 : FIZZ  ." FIZZ" ;
 : BUZZ  ." BUZZ" ;

CASE: SELECT ( n -- ) | FOO  | BAR | FIZZ | BUZZ  ;CASE

\ Usage:  3 SELECT
