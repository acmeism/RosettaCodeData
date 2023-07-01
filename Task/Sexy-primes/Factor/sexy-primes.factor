USING: combinators.short-circuit fry interpolate io kernel
literals locals make math math.primes math.ranges prettyprint qw
sequences tools.memory.private ;
IN: rosetta-code.sexy-primes

CONSTANT: limit 1,000,035
CONSTANT: primes $[ limit primes-upto ]
CONSTANT: tuplet-names qw{ pair triplet quadruplet quintuplet }

: tuplet ( m n -- seq ) dupd 1 - 6 * + 6 <range> ;

: viable-tuplet? ( seq -- ? )
    [ [ prime? ] [ limit < ] bi and ] all? ;

: sexy-tuplets ( n -- seq ) [ primes ] dip '[
        [ _ tuplet dup viable-tuplet? [ , ] [ drop ] if ] each
    ] { } make ;

: ?last5 ( seq -- seq' ) 5 short tail* ;

: last5 ( seq -- str )
    ?last5 [ { } like unparse ] map " " join ;

:: tuplet-info ( n -- last5 l5-len num-tup limit tuplet-name )
    n sexy-tuplets :> tup tup last5 tup ?last5 length tup length
    commas limit commas n 2 - tuplet-names nth ;

: show-tuplets ( n -- )
    tuplet-info
    [I Number of sexy prime ${0}s < ${1}: ${2}I] nl
    [I Last ${0}: ${1}I] nl nl ;

: unsexy-primes ( -- seq ) primes [
        { [ 6 + prime? not ] [ 6 - prime? not ] } 1&&
    ] filter ;

: show-unsexy ( -- )
    unsexy-primes dup length commas limit commas
    [I Number of unsexy primes < ${0}: ${1}I] nl
    "Last 10: " write 10 short tail* [ pprint bl ] each nl ;

: main ( -- ) 2 5 [a,b] [ show-tuplets ] each show-unsexy ;

MAIN: main
