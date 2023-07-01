USING: combinators.short-circuit formatting io kernel lists
lists.lazy literals math math.parser sequences tools.time ;
IN: rosetta-code.2-3-palindromes

CONSTANT: info $[
    "The first 6 numbers which are palindromic in both binary "
    "and ternary:" append
]

: expand ( n -- m ) 3 >base dup <reversed> "1" glue 3 base> ;

: 2-3-pal? ( n -- ? )
    expand >bin
    { [ length odd? ] [ dup <reversed> sequence= ] } 1&& ;

: first6 ( -- seq )
    4 0 lfrom [ 2-3-pal? ] lfilter ltake list>array
    [ expand ] map { 0 1 } prepend ;

: main ( -- )
    info print nl first6 [
        dup [ >bin ] [ 3 >base ] bi
        "Decimal : %d\nBinary  : %s\nTernary : %s\n\n" printf
    ] each ;

[ main ] time
