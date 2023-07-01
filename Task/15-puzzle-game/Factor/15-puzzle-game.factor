USING: accessors combinators combinators.extras
combinators.short-circuit grouping io kernel literals math
math.matrices math.order math.parser math.vectors prettyprint qw
random sequences sequences.extras ;
IN: rosetta-code.15-puzzle-game

<<

TUPLE: board matrix zero ;

: <board> ( -- board )
    16 <iota> 1 rotate 4 group { 3 3 } board boa ;

>>

CONSTANT: winning $[ <board> matrix>> ]

: input>dir ( str -- pair )
    {
        { "u" [ { 1 0 } ] }
        { "d" [ { -1 0 } ] }
        { "l" [ { 0 1 } ] }
        { "r" [ { 0 -1 } ] }
    } case ;

: get-index ( loc matrix -- elt ) [ first2 swap ] dip nth nth ;

: mexchange ( loc1 loc2 matrix -- )
    tuck [ [ [ get-index ] keepd ] 2bi@ ] keep [ spin ] 2dip
    [ set-index ] keep set-index ;

: vclamp+ ( seq1 seq2 -- seq ) v+ { 0 0 } { 3 3 } vclamp ;

: slide-piece ( board str -- )
    over zero>> [ vclamp+ ] keep rot matrix>> mexchange ;

: move-zero ( board str -- )
    [ vclamp+ ] curry change-zero drop ;

: move ( board str -- )
    input>dir [ slide-piece ] [ move-zero ] 2bi ;

: rand-move ( board -- ) qw{ u d l r } random move ;

: shuffle-board ( board n -- board' ) [ dup rand-move ] times ;

: .board ( board -- ) matrix>> simple-table. ;

: get-input ( -- str )
    "Your move? (u/d/l/r/q) " write flush readln dup
    qw{ u d l r q } member? [ drop get-input ] unless ;

: won? ( board -- ? ) matrix>> winning = ;

DEFER: game
: process-input ( board -- board' )
    get-input dup "q" = [ drop ] [ game ] if ;

: check-win ( board -- board' )
    dup won? [ "You won!" print ] [ process-input ] if ;

: game ( board str -- board' )
    [ move ] keepd dup .board check-win ;

: valid-difficulty? ( obj -- ? )
    { [ fixnum? ] [ 3 100 between? ] } 1&& ;

: choose-difficulty ( -- n )
    "How many shuffles? (3-100) " write flush readln
    string>number dup valid-difficulty?
    [ drop choose-difficulty ] unless ;

: main ( -- )
    <board> choose-difficulty shuffle-board dup .board check-win
    drop ;

MAIN: main
