USING: formatting fry grouping.extras io kernel math
math.primes.factors math.ranges math.statistics sequences
tools.memory.private ;
IN: rosetta-code.chowla-numbers

: chowla ( n -- m )
    dup 1 = [ 1 - ] [ [ divisors sum ] [ - 1 - ] bi ] if ;

: show-chowla ( n -- )
    [1,b] [ dup chowla "chowla(%02d) = %d\n" printf ] each ;

: count-primes ( seq -- )
    dup 0 prefix [ [ 1 + ] dip 2 <range> ] 2clump-map
    [ [ chowla zero? ] count ] map cum-sum
    [ [ commas ] bi@ "Primes up to %s: %s\n" printf ] 2each ;

: show-perfect ( n -- )
    [ 2 3 ] dip '[ 2dup * dup _ > ] [
        dup [ chowla ] [ 1 - = ] bi
        [ commas "%s is perfect\n" printf ] [ drop ] if
        [ nip 1 + ] [ nip dupd + ] 2bi
    ] until 3drop ;

: chowla-demo ( -- )
    37 show-chowla nl { 100 1000 10000 100000 1000000 10000000 }
    count-primes nl 35e7 show-perfect ;

MAIN: chowla-demo
