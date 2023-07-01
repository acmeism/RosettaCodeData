USING: kernel interpolate io locals math.statistics prettyprint
random sequences ;
IN: rosetta-code.simple-moving-avg

:: I ( P -- quot )
    V{ } clone :> v!
    [ v swap suffix! P short tail* v! ] ;

: sma-add ( quot n -- quot' ) swap tuck call( x x -- x ) ;

: sma-query ( quot -- avg v ) first concat dup mean swap ;

: simple-moving-average-demo ( -- )
    5 I 10 <iota> [
        over sma-query unparse
        [I After ${2} numbers Sequence is ${0} Mean is ${1}I] nl
        100 random sma-add
    ] each drop ;

MAIN: simple-moving-average-demo
