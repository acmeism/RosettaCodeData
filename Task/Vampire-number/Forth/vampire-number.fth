: sqrt ( u -- sqrt )            ( Babylonian method                 )
  dup 2/                        ( first square root guess is half   )
  dup 0= if drop exit then      ( sqrt[0]=0, sqrt[1]=1              )
  begin dup >r 2dup / r> + 2/   ( stack: square old-guess new-guess )
  2dup > while                  ( as long as guess is decreasing    )
  nip repeat                    ( forget old-guess and repeat       )
  drop nip ;

: ndigits ( n -- n )  10 / dup 0<> if recurse then 1+ ;

: dtally ( n -- n )
  10 /mod
  dup 0<> if recurse then
  swap   6 *   1 swap lshift   + ;

: ?product ( x a b -- f ) * = ;
: ?dtally  ( x a b -- f ) dtally rot dtally rot dtally rot   + = ;
: ?ndigits ( a b -- f )   ndigits swap ndigits = ;
: ?0trail  ( a b -- f )   10 mod 0= swap 10 mod 0= and invert ;

: ?fang ( x a -- f )
  2dup / 2>r
  dup  2r@ ?product
  swap 2r@ ?dtally  and
       2r@ ?ndigits and
       2r> ?0trail  and ;

: next-fang ( n a -- false | a true )
  over sqrt swap 1+ ?do
    dup i ?fang if   drop i true unloop exit    then
  loop drop false ;

: ?vampire ( n -- false | a true ) 0 next-fang ;

: next-vampire ( n -- n a )  begin  1+  dup ?vampire until ;

: .product ( n a -- )  dup . ." x " / . ." = " ;

: .vampire ( n a -- )
  cr
  begin 2dup .product
        over swap next-fang
  while repeat
  . ;

: .fangs ( n -- )  dup ?vampire if .vampire else cr . ." is not vampiric." then ;

: vampires ( n -- )
  1 swap
  0 do  next-vampire over swap .vampire  loop drop ;

25 vampires
16758243290880 .fangs
24959017348650 .fangs
14593825548650 .fangs
