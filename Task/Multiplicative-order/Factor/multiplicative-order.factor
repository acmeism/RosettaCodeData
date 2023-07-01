USING: kernel math math.functions math.primes.factors sequences ;

: (ord) ( a pair -- n )
    first2 dupd ^ swap dupd [ /i ] keep 1 - * divisors
    [ swap ^mod 1 = ] 2with find nip ;


: ord ( a n -- m )
    2dup gcd nip 1 =
    [ group-factors [ (ord) ] with [ lcm ] map-reduce ]
    [ 2drop 0/0. ] if ;
