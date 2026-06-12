USING: grouping kernel math.functions math.parser
math.primes.factors math.ranges prettyprint sequences ;

: reverse-number ( n -- reversed ) 10 >base reverse dec> ;

: special? ( n -- ? )
    [ reverse-number ] [ divisors ] bi
    [ reverse-number divisor? ] with all? ;

200 [1..b] [ special? ] filter 18 group simple-table.
