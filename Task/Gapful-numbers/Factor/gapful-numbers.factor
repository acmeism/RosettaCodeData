USING: formatting kernel lists lists.lazy math math.functions
math.text.utils sequences ;

: gapful? ( n -- ? )
    dup 1 digit-groups [ first ] [ last 10 * + ] bi divisor? ;

30 100 15 1,000,000 10 1,000,000,000 [
    2dup lfrom [ gapful? ] lfilter ltake list>array
    "%d gapful numbers starting at %d:\n%[%d, %]\n\n" printf
] 2tri@
