USING: accessors combinators.random continuations formatting io
kernel math math.functions math.parser multiline qw random
sequences ;
IN: rosetta-code.21-game

STRING: welcome
21 is a two-player game. The game is played by choosing a number
(1, 2, or 3) to be added to the running total.

The game is won by the player whose chosen number causes the
running total to reach 21.

One player will be the computer. Players alternate supplying a
number to be added to the running total.
;

: .welcome ( -- ) welcome print ;

SYMBOLS: +computer+ +human+ ;

TUPLE: game total difficulty who ;

! Instead of saying something dry like 'invalid input,' spice
! it up a little.
: insult ( -- )
    {
        "No." "Er..." "Learn to read." "I think not."
        "Come on, is it really this difficult?"
    } random print ;

: get-input ( options-seq prompt-str -- str )
    dup "%s: " printf flush readln dup reach member?
    [ 2nip ] [ drop insult get-input ] if ;

: get-integer ( options-seq prompt-str -- n )
    get-input string>number ;

: get-difficulty ( -- x )
    qw{ 1 2 3 4 5 6 7 8 9 10 }
    "Difficulty (1-10)" get-integer 10 / ;

: human-move ( game -- n )
    drop qw{ q 1 2 3 } "Your move (1-3) or q to quit" get-input
    dup "q" = [ drop return ] when string>number ;

: choose-first-player ( difficulty -- player )
    [ +computer+ ] [ +human+ ] ifp ;

: <game> ( -- game )
    0 get-difficulty dup choose-first-player game boa ;

: swap-player ( game -- )
    [ +human+ = +computer+ +human+ ? ] change-who drop ;

: .total ( game -- ) total>> "Running total: %d\n" printf ;

: random-move ( game -- n ) drop 3 random 1 + ;

: boundary? ( n -- ? ) 1 - 4 divisor? ;

: (optimal-move) ( m -- n ) dup 4 / ceiling 4 * 1 + swap - ;

: optimal-move ( game -- n )
    total>> dup boundary? [ random-move ] [ (optimal-move) ] if ;

: computer-move ( game -- n )
    dup difficulty>> [ optimal-move ] [ random-move ] ifp
    dup "Computer chose %d.\n" printf ;

: do-turn ( game -- )
    dup dup who>> +human+ = [ human-move ] [ computer-move ] if
    [ + ] curry change-total dup .total swap-player ;

: do-turns ( game -- )
    [ dup total>> 20 > ] [ dup do-turn ] until
    dup swap-player who>> "%u wins!\n" printf ;

: play-21-game ( -- )
    .welcome nl [ <game> do-turns ] with-return ;

MAIN: play-21-game
