USING: arrays formatting io kernel lists lists.lazy math
math.primes.factors sequences tools.memory.private ;
IN: rosetta-code.abundant-odd-numbers

: σ ( n -- sum ) divisors sum ;
: abundant? ( n -- ? ) [ σ ] [ 2 * ] bi > ;
: abundant-odds-from ( n -- list )
    dup even? [ 1 + ] when
    [ 2 + ] lfrom-by [ abundant? ] lfilter ;

: first25 ( -- seq ) 25 1 abundant-odds-from ltake list>array ;
: 1,000th ( -- n ) 999 1 abundant-odds-from lnth ;
: first>10^9 ( -- n ) 1,000,000,001 abundant-odds-from car ;

GENERIC: show ( obj -- )
M: integer show dup σ [ commas ] bi@ "%-6s σ = %s\n" printf ;
M: array show [ show ] each ;

: abundant-odd-numbers-demo ( -- )
    first25 "First 25 abundant odd numbers:"
    1,000th "1,000th abundant odd number:"
    first>10^9 "First abundant odd number > one billion:"
    [ print show nl ] 2tri@ ;

MAIN: abundant-odd-numbers-demo
