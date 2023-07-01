USING: combinators formatting io kernel math math.ranges qw
random sequences ;
IN: rosetta-code.rock-paper-scissors

CONSTANT: thing qw{ rock paper scissors }
CONSTANT: msg { "I win." "Tie!" "You win." }

: ai-choice ( r p s -- n )
    3dup + + nip [1,b] random {
        { [ 3dup nip >= ] [ 3drop 1 ] }
        { [ 3dup [ + ] dip >= ] [ 3drop 2 ] }
        [ 3drop 0 ]
    } cond ;

: player-choice ( -- n )
    "r/p/s/q? " write readln qw{ r p s q } index dup
    [ drop player-choice ] unless ;

! return:
! -1 for n1 loses to n2.
!  0 for n1 ties n2.
!  1 for n1 beats n2.
: outcome ( n1 n2 -- n3 ) - dup abs 1 > [ neg ] when sgn ;

: status. ( seq -- )
    "My wins: %d  Ties: %d  Your wins: %d\n" vprintf ;

: choices. ( n1 n2 -- )
    [ thing nth ] bi@ "You chose: %s\nI chose: %s\n" printf ;

: tally ( seq n -- seq' ) over [ 1 + ] change-nth ;

: game ( seq -- seq' )
    dup status. player-choice dup 3 = [ drop ] [
        [ 3 + tally ] keep over 3 tail* first3 ai-choice 2dup
        choices. outcome 1 + dup [ tally ] dip msg nth print nl
        game
    ] if ;

! The game state is a sequence where the members are:
! losses, ties, wins, #rock, #paper, #scissors
: main ( -- ) { 0 0 0 1 1 1 } clone game drop ;

MAIN: main
