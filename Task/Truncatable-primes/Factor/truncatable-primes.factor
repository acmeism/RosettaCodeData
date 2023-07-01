USING: formatting fry grouping.extras kernel literals math
math.parser math.primes sequences ;
IN: rosetta-code.truncatable-primes

CONSTANT: primes $[ 1,000,000 primes-upto reverse ]

: number>digits ( n -- B{} ) number>string string>digits ;

: no-zeros? ( seq -- ? ) [ zero? not ] all? ;

: all-prime? ( seq -- ? ) [ prime? ] all? ;

: truncate ( seq quot -- seq' ) call( seq -- seq' )
    [ 10 digits>integer ] map ;

: truncate-right ( seq -- seq' ) [ head-clump ] truncate ;

: truncate-left ( seq -- seq' ) [ tail-clump ] truncate ;

: truncatable-prime? ( n quot -- ? ) [ number>digits ] dip
    '[ @ all-prime? ] [ no-zeros? ] bi and ; inline

: right-truncatable-prime? ( n -- ? ) [ truncate-right ]
    truncatable-prime? ;

: left-truncatable-prime? ( n -- ? ) [ truncate-left ]
    truncatable-prime? ;

: find-truncatable-primes ( -- ltp rtp )
    primes [ [ left-truncatable-prime?  ] find nip ]
           [ [ right-truncatable-prime? ] find nip ] bi ;

: main ( -- ) find-truncatable-primes
    "Left: %d\nRight: %d\n" printf ;

MAIN: main
