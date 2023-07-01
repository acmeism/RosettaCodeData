USING: assocs combinators.short-circuit formatting kernel math
math.parser regexp sequences sets qw unicode ;
IN: rosetta-code.iban

<PRIVATE

CONSTANT: countries H{
    { 15 qw{ NO } }
    { 16 qw{ BE } }
    { 18 qw{ DK FO FI GL NL } }
    { 19 qw{ MK SI } }
    { 20 qw{ AT BA EE KZ LT LU } }
    { 21 qw{ CR HR LV LI CH } }
    { 22 qw{ BH BG GE DE IE ME RS GB } }
    { 23 qw{ GI IL AE } }
    { 24 qw{ AD CZ MD PK RO SA SK ES SE TN VG } }
    { 25 qw{ PT } }
    { 26 qw{ IS TR } }
    { 27 qw{ FR GR IT MR MC SM } }
    { 28 qw{ AL AZ CY DO GT HU LB PL } }
    { 29 qw{ BR PS } }
    { 30 qw{ KW MU } }
    { 31 qw{ MT } }
}

: valid-chars? ( str -- ? ) R/ [A-Z0-9]+/ matches? ;

: valid-length? ( str -- ? )
    [ 2 head ] [ length ] bi countries at member? ;

: valid-checksum? ( str -- ? )
    4 cut swap append [ digit> number>string ] { } map-as
    concat string>number 97 mod 1 = ;

PRIVATE>

: valid-iban? ( str -- ? )
    " " without {
        [ valid-chars? ] [ valid-length? ] [ valid-checksum? ]
    } 1&& ;

: iban-demo ( -- )
    "GB82 WEST 1234 5698 7654 32"
    "GB82 TEST 1234 5698 7654 32"
    [
        dup valid-iban? "may be a valid" "is an invalid" ?
        "%s %s IBAN\n" printf
    ] bi@ ;

MAIN: iban-demo
