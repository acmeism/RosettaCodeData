USING: formatting io kernel lists lists.lazy math math.functions
math.primes.factors sequences ;

: lfermats ( -- list )
    0 lfrom [ [ 1 2 2 ] dip ^ ^ + ] lmap-lazy ;

CHAR: ₀ 10 lfermats ltake list>array [
    "First 10 Fermat numbers:" print
    [ dupd "F%c = %d\n" printf 1 + ] each drop nl
] [
    "Factors of first few Fermat numbers:" print [
        dupd factors dup length 1 = " (prime)" "" ?
        "Factors of F%c: %[%d, %]%s\n" printf 1 +
    ] each drop
] 2bi
