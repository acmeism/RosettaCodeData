USING: formatting grouping io kernel literals make math
math.functions namespaces qw sequences sequences.extras ;
IN: rosetta-code.freecell

CONSTANT: max-rand-ms $[ 1 15 shift 1 - ]
CONSTANT: suits qw{ C D H S }
CONSTANT: ranks qw{ A 2 3 4 5 6 7 8 9 T J Q K }
SYMBOL: seed

: (random) ( n1 n2 -- n3 ) seed get * + dup seed set ;

: rand-ms ( -- n )
    max-rand-ms 2531011 214013 (random) -16 shift bitand ;

: init-deck ( -- seq )
    ranks suits [ append ] cartesian-map concat V{ } like ;

: swap-cards ( seq -- seq' )
    rand-ms over length [ mod ] [ 1 - ] bi pick exchange ;

: (deal) ( seq -- seq' )
    [ [ swap-cards dup pop , ] until-empty ] { } make ;

: deal ( game# -- seq ) seed set init-deck (deal) ;

: .cards ( seq -- ) 8 group [ [ write bl ] each nl ] each nl ;

: .game ( game# -- ) dup "Game #%d\n" printf deal .cards ;

: freecell ( -- ) 1 617 [ .game ] bi@ ;

MAIN: freecell
