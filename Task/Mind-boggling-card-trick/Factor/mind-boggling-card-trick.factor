USING: accessors combinators.extras formatting fry
generalizations io kernel math math.ranges random sequences
sequences.extras ;
IN: rosetta-code.mind-boggling-card-trick

SYMBOLS: R B ;

TUPLE: piles deck red black discard ;

: initialize-deck ( -- seq )
    [ R ] [ B ] [ '[ 26 _ V{ } replicate-as ] call ] bi@ append
    randomize ;

: <piles> ( -- piles )
    initialize-deck [ V{ } clone ] thrice piles boa ;

: deal-step ( piles -- piles' )
    dup [ deck>> pop dup ] [ discard>> push ] [ deck>> pop ] tri
    B = [ over black>> ] [ over red>> ] if push ;

: deal ( piles -- piles' ) 26 [ deal-step ] times ;

: choose-sample-size ( piles -- n )
    [ red>> ] [ black>> ] bi shorter length [0,b] random ;

! Partition a sequence into n random samples in one sequence and
! the leftovers in another.
: sample-partition ( vec n -- leftovers sample )
    [ 3 dupn ] dip sample dup
    [ [ swap remove-first! drop ] with each ] dip ;

: perform-swaps ( piles -- piles' )
    dup dup choose-sample-size dup "Swapping %d\n" printf
    [ [ red>> ] dip ] [ [ black>> ] dip ] 2bi
    [ sample-partition ] 2bi@ [ append ] dip rot append
    [ >>black ] dip >>red ;

: test-assertion ( piles -- )
    [ red>> ] [ black>> ] bi
    [ [ R = ] count ] [ [ B = ] count ] bi* 2dup =
    [ "Assertion correct!" ]
    [ "Assertion incorrect!" ] if print
    "R in red: %d\nB in black: %d\n" printf ;

: main ( -- )
    <piles>                             ! step 1
    deal                                ! step 2
    dup "Post-deal state:\n%u\n" printf
    perform-swaps                       ! step 3
    dup "Post-swap state:\n%u\n" printf
    test-assertion ;                    ! step 4

MAIN: main
