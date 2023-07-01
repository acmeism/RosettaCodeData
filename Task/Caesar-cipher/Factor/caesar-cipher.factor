USING: io kernel locals math sequences unicode.categories ;
IN: rosetta-code.caesar-cipher

:: cipher ( n s -- s' )
    [| c |
        c Letter? [
            c letter? CHAR: a CHAR: A ? :> a
            c a - n + 26 mod a +
        ]
        [ c ] if
    ] :> shift
    s [ shift call ] map ;

: encrypt ( n s -- s' ) cipher ;
: decrypt ( n s -- s' ) [ 26 swap - ] dip cipher ;

11 "Esp bftnv mczhy qzi ufxapo zgpc esp wlkj ozr." decrypt print
11 "The quick brown fox jumped over the lazy dog." encrypt print
