USING: grouping io kernel literals math.combinatorics
prettyprint qw random sequences sequences.product sets ;

CONSTANT: cards $[
    qw{
        one two three
        solid open striped
        red green purple
        diamond oval squiggle
    } 3 group <product-sequence>
]

: deal ( n -- seq ) cards swap sample ;

: set? ( seq -- ? ) cardinality { 1 3 } member? ;

: sets ( seq -- newseq )
    3 [ flip [ set? ] all? ] filter-combinations ;

: .length ( seq str -- ) write bl length . nl ;

: .cards ( seq -- )
    [ " " join dup "o" head? "" "s" ? append print ] each nl ;

: .sets ( seq -- )
    dup "Sets present:" .length [ .cards ] each ;

: play ( n -- )
    deal [ "Cards dealt:" .length ]
         [ .cards ]
         [ sets .sets ] tri ;

4 8 12 [ play ] tri@
