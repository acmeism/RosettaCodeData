USING: formatting io kernel lists lists.lazy locals math
math.ranges prettyprint sequences ;
IN: rosetta-code.stern-brocot

: fn ( n -- m )
    [ 1 0 ] dip
    [ dup zero? ] [
        dup 1 bitand zero?
        [ dupd [ + ] 2dip        ]
        [ [ dup ] [ + ] [ ] tri* ] if
        -1 shift
    ] until drop nip ;

:: search ( n -- m )
    1 0 lfrom [ fn n = ] lfilter ltake list>array first ;

: first15 ( -- )
    15 [1,b] [ fn pprint bl ] each
    "are the first fifteen." print ;

: first-appearances ( -- )
    10 [1,b] 100 suffix
    [ dup search "First %3u at Stern #%u.\n" printf ] each ;

: gcd-test ( -- )
    1,000 [1,b] [ dup 1 + [ fn ] bi@ gcd nip 1 = not ] filter
    empty? "" " not" ? "All GCDs are%s 1.\n" printf ;

: main ( -- ) first15 first-appearances gcd-test ;

MAIN: main
