a-function         \ requiring no arguments
a-function         \ with a fixed number of arguents
a-function         \ having optional arguments
a-function         \ having a variable number of arguments
a-function         \ having such named arguments as we have in Forth
' a-function var ! \ using a function in a first-class context (here: storing it in a variable)
a-function         \ in which we obtain a function's return value

                   \ forth lacks 'statement contenxt'
                   \ forth doesn't distinguish between built-in and user-defined functions
                   \ forth doesn't distinguish between functions and subroutines
                   \ forth doesn't care about by-value or by-reference

\ partial application is achieved by creating functions and manipulating stacks
: curried  0 a-function ;
: only-want-third-argument 1 2 rot a-function ;

\ Realistic example:
: move ( delta-x delta-y -- )
  y +!  x +! ;

: down ( n -- )  0 swap move ;
: up ( n -- )    negate down ;
: right ( n -- ) 0 move ;
: left ( n -- )  negate right ;
