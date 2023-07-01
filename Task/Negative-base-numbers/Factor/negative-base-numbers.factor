USING: formatting fry kernel make math math.combinators
math.extras math.functions math.parser sequences ;

: /mod* ( x y -- z w )
    [ /mod ] keep '[ [ 1 + ] dip _ abs + ] when-negative ;

: >nega ( n radix -- str )
    [ '[ _ /mod* # ] until-zero ] "" make reverse ;

: nega> ( str radix -- n )
    swap <reversed> [ ^ swap digit> * ] with map-index sum ;

: .round-trip ( n radix -- )
    dupd [ >nega ] keep 2dup 2dup nega>
    "%d_10 is %s_%d\n%s_%d is %d_10\n\n" printf ;

10 -2 146 -3 15 -10 [ .round-trip ] 2tri@
