USING: formatting grouping io kernel math math.functions
math.primes.factors prettyprint ranges sequences
tools.memory.private ;

: totient-sum ( n -- sum )
    [1..b] [ totient ] map-sum ;

: a ( n -- a(n) )
    dup [ 1 - * 2 / ] keep totient-sum - ;

"Number of pairs with common factors - first 100 terms:" print
100 [1..b] [ a commas ] map 10 group simple-table. nl

7 <iota> [ dup 10^ a commas "Term #1e%d: %s\n" printf ] each
