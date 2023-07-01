: fac ( n -- n! ) 1 swap 1+ 2 max 2 ?do i * loop ;

: main  ." 10! = " [ 10 fac ] literal . ;

see main
: main
  .\" 10! = " 3628800 . ; ok
