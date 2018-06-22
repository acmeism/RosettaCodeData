USING: arrays formatting io kernel literals math prettyprint
random sequences strings ;
FROM: math.extras => ... ;
IN: rosetta-code.evolutionary-algorithm

CONSTANT: target "METHINKS IT IS LIKE A WEASEL"
CONSTANT: mutation-rate 0.1
CONSTANT: num-children 25
CONSTANT: valid-chars
    $[ CHAR: A ... CHAR: Z >array { 32 } append ]

: rand-char ( -- n )
    valid-chars random ;

: new-parent ( -- str )
    target length [ rand-char ] replicate >string ;

: fitness ( str -- n )
    target [ = ] { } 2map-as sift length ;

: mutate ( str rate -- str/str' )
    [ random-unit > [ drop rand-char ] when ] curry map ;

: next-parent ( str -- str/str' )
    dup [ mutation-rate mutate ] curry num-children 1 - swap
    replicate [ 1array ] dip append [ fitness ] supremum-by ;

: print-parent ( str -- )
    [ fitness pprint bl ] [ print ] bi ;

: main ( -- )
    0 new-parent
    [ dup target = ]
    [ next-parent dup print-parent [ 1 + ] dip ] until drop
    "Finished in %d generations." printf ;

MAIN: main
