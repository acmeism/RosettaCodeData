USING: arrays backtrack combinators.short-circuit formatting
fry grouping io kernel literals math.combinatorics math.matrices
prettyprint qw random sequences sets ;
IN: rosetta-code.set-puzzle

CONSTANT: deck $[
    [
        qw{ red green purple } amb-lazy
        qw{ one two three } amb-lazy
        qw{ oval squiggle diamond } amb-lazy
        qw{ solid open striped } amb-lazy 4array
    ] bag-of
]

: valid-category? ( seq -- ? )
    { [ all-equal? ] [ all-unique? ] } 1|| ;

: valid-set? ( seq -- ? )
    [ valid-category? ] column-map t [ and ] reduce ;

: find-sets ( seq -- seq )
    3 <combinations> [ valid-set? ] filter ;

: deal-hand ( m n -- seq valid? )
    [ deck swap sample ] dip over find-sets length = ;

: find-valid-hand ( m n -- seq )
    [ f ] 2dip '[ drop _ _ deal-hand not ] loop ;

: set-puzzle ( m n -- )
    [ find-valid-hand ] 2keep
    [ "Dealt %d cards:\n" printf simple-table. nl ]
    [
        "Containing %d sets:\n" printf find-sets
        { { " " " " " " " " } } join simple-table. nl
    ] bi-curry* bi ;

: main ( -- )
    9  4 set-puzzle
    12 6 set-puzzle ;

MAIN: main
