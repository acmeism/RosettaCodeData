USING: io kernel math math.parser math.primes.erato math.ranges
sequences tools.memory.private ;

: twin-pair-count ( n -- count )
    [ 5 swap 2 <range> ] [ sieve ] bi
    [ over 2 - over [ marked-prime? ] 2bi@ and ] curry count ;

"Search size: " write flush readln string>number
twin-pair-count commas write " twin prime pairs." print
