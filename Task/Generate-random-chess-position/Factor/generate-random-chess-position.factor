USING: combinators.short-circuit grouping io kernel math
math.parser math.ranges math.vectors prettyprint random
sequences sets splitting.monotonic strings ;
IN: rosetta-code.random-chess-position

<PRIVATE

CONSTANT: pieces "RNBQBNRPPPPPPPPrnbqbnrpppppppp"
CONSTANT: empty CHAR: .

: <empty-board> ( -- seq ) 64 [ empty ] "" replicate-as ;
: empty-index ( seq -- n ) empty swap indices random ;
: place ( seq elt n -- seq' ) rot [ set-nth ] keep ;

! return a list of indices that are adjacent to n
: adj ( n -- seq )
    [ 1 - ] [ 1 + ] bi [a,b] { 8 8 8 } [ v- ] 2keep dupd v+
    append append ;

: rand-non-adjacent ( m -- n ) 64 <iota> swap adj diff random ;

: place-kings ( seq -- seq' )
    CHAR: K over empty-index [ place ] keep [ CHAR: k ] dip
    rand-non-adjacent place ;

: non-pawn ( seq elt -- seq' ) over empty-index place ;

! prevent placing of pawns in ranks 1 and 8
: pawn ( seq elt -- seq' )
    over empty swap indices
    [ { [ 7 > ] [ 56 < ] } 1&& ] filter random place ;

: place-piece ( seq -- seq' )
    pieces random dup "Pp" member? [ pawn ] [ non-pawn ] if ;

PRIVATE>


: position ( -- seq )
    <empty-board> place-kings 30 random [ place-piece ] times ;

: position. ( seq -- )
    [ 1string ] { } map-as 8 group simple-table. ;

: position>fen ( seq -- seq' )
    8 group [
        [ = ] monotonic-split
        [ dup first empty = [ length number>string ] when ]
        map concat
    ] map "/" join "/ w - - 0 1" append ;

: random-chess-position-demo ( -- )
    position [ position. ] [ position>fen print ] bi ;

MAIN: random-chess-position-demo
