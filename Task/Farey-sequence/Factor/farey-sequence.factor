USING: formatting io kernel math math.primes.factors math.ranges
locals prettyprint sequences sequences.extras sets tools.time ;
IN: rosetta-code.farey-sequence

! Given the order n and a farey pair, calculate the next member
! of the sequence.
:: p/q ( n a/b c/d -- p/q )
    a/b c/d [ >fraction ] bi@ :> ( a b c d )
    n b + d / >integer [ c * a - ] [ d * b - ] bi / ;

: print-farey ( order -- )
    [ "F(%-2d): " printf ] [ 0 1 pick / ] bi "0/1 " write
    [ dup 1 = ] [ dup pprint bl 3dup p/q [ nip ] dip ] until
    3drop "1/1" print ;

: φ ( n -- m ) ! Euler's totient function
    [ factors members [ 1 swap recip - ] map-product ] [ * ] bi ;

: farey-length ( order -- length )
   dup 1 = [ drop 2 ]
   [ [ 1 - farey-length ] [ φ ] bi + ] if ;

: part1 ( -- ) 11 [1,b] [ print-farey ] each nl ;

: part2 ( -- )
    100 1,000 100 <range>
    [ dup farey-length "F(%-4d): %-6d members.\n" printf ] each ;

: main ( -- ) [ part1 part2 nl ] time ;

MAIN: main
