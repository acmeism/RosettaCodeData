USING: io kernel math math.order math.parser math.ranges qw
sequences ;
IN: rosetta-code.nth

: n'th ( n -- str )
    dup 10 /mod swap 1 = [ drop 0 ] when
    [ number>string ]
    [ 4 min qw{ th st nd rd th } nth ] bi* append ;

: n'th-demo ( -- )
    0 25 250 265 1000 1025 [ [a,b] ] 2tri@
    [ [ n'th write bl ] each nl ] tri@ ;

MAIN: n'th-demo
