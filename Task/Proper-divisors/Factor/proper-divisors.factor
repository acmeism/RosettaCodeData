USING: formatting io kernel math math.functions
math.primes.factors math.ranges prettyprint sequences ;

: #divisors ( m -- n )
    dup sqrt >integer 1 + [1,b] [ divisor? ] with count dup +
    1 - ;

10 [1,b] [ dup pprint bl divisors but-last . ] each
20000 [1,b] [ #divisors ] supremum-by dup #divisors
"%d with %d divisors.\n" printf
