USING: generalizations io kernel math math.functions
math.primes.factors math.ranges prettyprint sequences ;
IN: rosetta-code.arithmetic-rational

2/5              ! literal syntax 2/5
2/4              ! automatically simplifies to 1/2
5/1              ! automatically coerced to 5
26/5             ! mixed fraction 5+1/5
13/178 >fraction ! get the numerator and denominator 13 178
8 recip          ! get the reciprocal 1/8

! ratios can be any size
12417829731289312/61237812937138912735712
8 ndrop ! clear the stack
! arithmetic works the same as any other number.

: perfect? ( n -- ? )
    divisors rest [ recip ] map-sum 1 = ;

"Perfect numbers <= 2^19: " print
2 19 ^ [1,b] [ perfect? ] filter .
