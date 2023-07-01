USING: arrays assocs formatting fry generalizations io kernel
math math.ranges math.statistics math.vectors sequences
splitting.monotonic ;
IN: rosetta-code.ranking

CONSTANT: ranks {
    { 44 "Solomon" } { 42 "Jason" } { 42 "Errol" }
    { 41 "Garry" } { 41 "Bernard" } { 41 "Barry" }
    { 39 "Stephen" }
}

: rank ( seq quot -- seq' )
    '[ [ = ] monotonic-split [ length ] map dup @ [ <array> ]
    2map concat ] call ; inline

: standard ( seq -- seq' ) [ cum-sum0 1 v+n ] rank ;
: modified ( seq -- seq' ) [ cum-sum ] rank ;
: dense    ( seq -- seq' ) [ length [1,b] ] rank ;
: ordinal  ( seq -- seq' ) length [1,b] ;

: fractional ( seq -- seq' )
    [ dup cum-sum swap [ dupd - [a,b) mean ] 2map ] rank ;

: .rank ( quot -- )
    [ ranks dup keys ] dip call swap
    [ first2 "%5u %d %s\n" printf ] 2each ; inline

: ranking-demo ( -- )
    "Standard ranking"   [ standard   ]
    "Modified ranking"   [ modified   ]
    "Dense ranking"      [ dense      ]
    "Ordinal ranking"    [ ordinal    ]
    "Fractional ranking" [ fractional ]
    [ [ print ] [ .rank nl ] bi* ] 2 5 mnapply ;

MAIN: ranking-demo
