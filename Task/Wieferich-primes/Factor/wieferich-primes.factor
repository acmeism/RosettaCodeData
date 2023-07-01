USING: io kernel math math.functions math.primes prettyprint
sequences ;

"Wieferich primes less than 5000:" print
5000 primes-upto [ [ 1 - 2^ 1 - ] [ sq divisor? ] bi ] filter .
