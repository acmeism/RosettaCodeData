USING: kernel math math.functions math.primes math.text.utils prettyprint sequences ;

100 <iota> [ [ sq ] [ 3 ^ ] bi [ 1 digit-groups sum prime? ] both? ] filter .
