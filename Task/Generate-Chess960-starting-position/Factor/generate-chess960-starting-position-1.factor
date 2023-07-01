USING: io kernel math random sequences ;
IN: rosetta-code.chess960

: empty ( seq -- n ) 32 swap indices random ;           ! return a random empty index (i.e. equal to 32) of seq
: next ( seq -- n ) 32 swap index ;                     ! return the leftmost empty index of seq
: place ( seq elt n -- seq' ) rot [ set-nth ] keep ;    ! set nth member of seq to elt, keeping seq on the stack

: white-bishop ( -- elt n ) CHAR: ♗ 4 random 2 * ;
: black-bishop ( -- elt n ) white-bishop 1 + ;
: queen ( seq -- seq elt n ) CHAR: ♕ over empty ;
: knight ( seq -- seq elt n ) CHAR: ♘ over empty ;
: rook ( seq -- seq elt n ) CHAR: ♖ over next ;
: king ( seq -- seq elt n ) CHAR: ♔ over next ;

: chess960 ( -- str )
    "        " clone
    black-bishop place
    white-bishop place
    queen place
    knight place
    knight place
    rook place
    king place
    rook place ;

: chess960-demo ( -- ) 5 [ chess960 print ] times ;

MAIN: chess960-demo
