( xt from :noname in the previous example )
variable pocket  pocket !
: fib ( +n -- n' )
  dup 0< abort" Negative numbers don't exist."
  [ pocket @ compile, ] ;
