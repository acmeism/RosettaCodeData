USING: combinators.short-circuit fry io kernel lists lists.lazy math
math.combinatorics math.functions math.primes.factors math.statistics
math.text.utils prettyprint sequences sets ;
IN: rosetta-code.vampire-number

: digits ( n -- m )
    log10 floor >integer 1 + ;

: same-digits? ( n n1 n2 -- ? )
    [ 1 digit-groups ] tri@ append [ histogram ] bi@ = ;

: half-len-factors ( n -- seq )
    [ divisors ] [ digits ] bi 2/ '[ digits _ = ] filter ;

: same-digit-factors ( n -- seq )
    dup half-len-factors 2 <combinations> [ first2 same-digits? ] with filter ;

: under-two-trailing-zeros? ( seq -- ? )
    [ 10 mod ] map [ 0 = ] count 2 < ;

: tentative-fangs ( n -- seq )
    same-digit-factors [ under-two-trailing-zeros? ] filter ;

: fangs ( n -- seq )
    [ tentative-fangs ] [ ] bi '[ product _ = ] filter ;

: vampire? ( n -- ? )
    { [ digits even? ] [ fangs empty? not ] } 1&& ;

: first25 ( -- seq )
    25 0 lfrom [ vampire? ] lfilter ltake list>array ;

: .vamp-with-fangs ( n -- )
    [ pprint bl ] [ fangs [ pprint bl ] each ] bi nl ;

: part1 ( -- )
    first25 [ .vamp-with-fangs ] each ;

: part2 ( -- ) { 16758243290880 24959017348650 14593825548650 }
    [ dup vampire? [ .vamp-with-fangs ] [ drop ] if ] each ;

: main ( -- ) part1 part2 ;

MAIN: main
