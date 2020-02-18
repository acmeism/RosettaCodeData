USING: assocs grouping io kernel math math.combinatorics
math.functions math.ranges math.statistics math.text.utils
prettyprint sequences sets ;
IN: rosetta-code.self-referential-sequence

: next-term ( seq -- seq ) histogram >alist concat ;

! Output the self-referential sequence, given a seed value.
: srs ( seq -- seq n )
    V{ } clone [ 2dup member? ] [ 2dup push [ next-term ] dip ]
    until nip dup length ;

: digit-before? ( m n -- ? ) dup zero? [ 2drop t ] [ <= ] if ;

! The numbers from 1 to n sans permutations.
: candidates ( n -- seq )
    [1,b] [ 1 digit-groups reverse ] map
    [ [ digit-before? ] monotonic? ] filter ;

: max-seed ( n -- seq ) candidates [ srs nip ] supremum-by ;

: max-seeds ( n -- seq )
    max-seed <permutations> members [ first zero? ] reject ;

: digits>number ( seq -- n ) [ 10^ * ] map-index sum ;

: >numbers ( seq -- seq ) [ digits>number ] map ;

: main ( -- )
    "Seed value(s): " write
    1,000,000 max-seeds
    [ [ reverse ] map >numbers . ]
    [ first srs ] bi
    "Iterations: " write .
    "Sequence:" print >numbers . ;

MAIN: main
