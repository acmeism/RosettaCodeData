USING: formatting kernel literals math math.functions
math.primes sequences ;
IN: rosetta-code.primorial-numbers

CONSTANT: primes $[ 1,000,000 nprimes ]

: digit-count ( n -- count ) log10 floor >integer 1 + ;

: primorial ( n -- m ) primes swap head product ;

: .primorial ( n -- ) dup primorial "Primorial(%d) = %d\n"
    printf ;

: .digit-count ( n -- ) dup primorial digit-count
    "Primorial(%d) has %d digits\n" printf ;

: part1 ( -- ) 10 iota [ .primorial ] each ;

: part2 ( -- ) { 10 100 1000 10000 100000 1000000 }
    [ .digit-count ] each ;

: main ( -- ) part1 part2 ;

MAIN: main
