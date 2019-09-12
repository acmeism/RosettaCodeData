USING: io kernel lists lists.lazy locals math math.functions
math.ranges prettyprint sequences ;

:: kaprekar? ( n -- ? )
    n sq :> sqr
    1 lfrom
    [ 10 swap ^ ] lmap-lazy
    [ n > ] lfilter
    [ sqr swap mod n < ] lwhile
    list>array
    [ 1 - sqr n - swap mod zero? ] any?
    n 1 = or ;

1,000,000 [1,b] [ kaprekar? ] filter dup . length
"Count of Kaprekar numbers <= 1,000,000: " write .
