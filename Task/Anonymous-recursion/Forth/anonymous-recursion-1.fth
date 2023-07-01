:noname ( n -- n' )
  dup 2 < ?exit
  1- dup recurse swap 1- recurse + ; ( xt )

: fib ( +n -- n' )
  dup 0< abort" Negative numbers don't exist."
  [ ( xt from the :NONAME above ) compile, ] ;
