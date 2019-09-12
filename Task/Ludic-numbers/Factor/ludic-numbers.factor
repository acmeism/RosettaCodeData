USING: formatting fry kernel make math math.ranges namespaces
prettyprint.config sequences sequences.extras ;
IN: rosetta-code.ludic-numbers

: next-ludic ( seq -- seq' )
    dup first '[ nip _ mod zero? not ] filter-index ;

: ludics-upto-2005 ( -- a )
    22,000 2 swap [a,b] [ ! 22k suffices to produce 2005 ludics
        1 , [ building get length 2005 = ]
        [ dup first , next-ludic ] until drop
    ] { } make ;

: ludic-demo ( -- )
    100 margin set ludics-upto-2005
    [ 6 tail* ] [ [ 1000 < ] count ] [ 25 head ] tri
    "First 25 ludic numbers:\n%u\n\n"
    "Count of ludic numbers less than 1000:\n%d\n\n"
    "Ludic numbers 2000 to 2005:\n%u\n" [ printf ] tri@ ;

MAIN: ludic-demo
