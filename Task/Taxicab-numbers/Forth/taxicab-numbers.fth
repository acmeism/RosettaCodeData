variable taxicablist
variable searched-cubessum
73 constant max-constituent \ uses magic numbers

: cube dup dup * * ;
: cubessum cube swap cube + ;

: ?taxicab ( a b -- c d true | false )
\ does exist an (c, d) such that c^3+d^3 = a^3+b^3 ?
  2dup cubessum searched-cubessum !
  dup 1- rot 1+ do   \ c is possibly in [a+1 b-2]
    dup i 1+ do      \ d is possibly in [c+1 b-1]
      j i cubessum searched-cubessum @ = if drop j i true unloop unloop exit then
    loop
  loop drop false ;

: swap-taxi ( n -- )
  dup 5 cells + swap do
    i @     i 5 cells - @     i !     i 5 cells - !
  cell +loop ;

: bubble-taxicablist
  here 5 cells - taxicablist @ = if exit then        \ not for the first one
  taxicablist @ here 5 cells - do
    i @     i 5 cells - @     > if unloop exit then  \ no (more) need to reorder
    i swap-taxi
  5 cells -loop ;

: store-taxicab ( a b c d -- )
  2dup cubessum , swap , , swap , ,
  bubble-taxicablist ;

: build-taxicablist
  here taxicablist !
  max-constituent 3 - 1 do         \ a in [ 1 ; max-3 ]
    i 3 + max-constituent swap do  \ b in [ a+3 ; max ]
      j i ?taxicab if j i store-taxicab then
    loop
  loop ;

: .nextcube cell + dup @ . ." ^3 " ;
: .taxi
  dup @ .
  ." = " .nextcube ." + " .nextcube ." = " .nextcube ." + " .nextcube
  drop ;

: taxicab 5 cells * taxicablist @ + ;

: list-taxicabs ( n -- )
  0 do
    cr I 1+ . ." : "
    I taxicab .taxi
  loop ;

build-taxicablist
25 list-taxicabs
