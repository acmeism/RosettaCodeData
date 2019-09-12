USING: io kernel math math.functions math.parser multiline
prettyprint sequences splitting ;
IN: rosetta-code.fractran

STRING: fractran-string
17/91 78/85 19/51 23/38 29/33 77/29 95/23
77/19 1/17 11/13 13/11 15/14 15/2 55/1
;

: fractran-parse ( str -- seq )
    " \n" split [ string>number ] map ;

: fractran-step ( seq n -- seq n'/f )
    2dup [ * integer? ] curry find nip dup [ * ] [ nip ] if ;

: fractran-run-full ( seq n -- )
    [ dup ] [ dup . fractran-step ] while 2drop ;

: fractran-run-limited ( seq n steps -- )
    [ dup pprint bl fractran-step ] times 2drop nl ;

: fractran-primes ( #primes seq n -- )
    [ pick zero? ] [
        dup 2 logn dup [ floor 1e-9 ~ ] [ 1. = not ] bi and [
            dup 2 logn >integer pprint bl [ 1 - ] 2dip
        ] when fractran-step
    ] until 3drop nl ;

: main ( -- )
    fractran-string fractran-parse 2
    [ "First 20 numbers: " print 20 fractran-run-limited nl ]
    [ "First 20 primes: " print [ 20 ] 2dip fractran-primes ]
    2bi ;

MAIN: main
