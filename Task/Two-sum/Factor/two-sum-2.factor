USING: accessors arrays assocs combinators.extras hashtables
kernel math math.combinatorics sequences ;
IN: rosetta-code.two-sum

DEFER: (two-sum)
TUPLE: helper sum seq index hash ;

: <two-sum-helper> ( sum seq -- helper )
    \ helper new
        swap [ >>seq ] keep length <hashtable> >>hash
        swap >>sum 0 >>index ;

: no-sum ( helper -- empty ) drop { } ;

: in-bounds? ( helper -- ? )
    [ index>> ] [ seq>> length ] bi < ;

: next-sum ( helper -- pair )
    dup in-bounds? [ (two-sum) ] [ no-sum ] if ;

: next-index ( helper -- helper ) [ 1 + ] change-index ;

: result ( helper index -- helper ) swap index>> 2array ;

: find-compliment-index ( helper -- helper index/f )
    dup [ sum>> ] [ index>> ] [ seq>> nth - ] [ ] quad hash>> at ;

: remember-item ( helper -- helper )
    dup [ hash>> ] [ index>> ] [ seq>> nth ] [ index>> ]
        quad set-of drop ;

: (two-sum) ( helper -- pair )
    remember-item find-compliment-index
        [ result ] [ next-index next-sum ] if* ;

: two-sum ( sum seq -- pair ) <two-sum-helper> (two-sum) ;

MAIN: [ { 21 55 11 } [ { 0 2 11 19 90 } two-sum . ] each ]
