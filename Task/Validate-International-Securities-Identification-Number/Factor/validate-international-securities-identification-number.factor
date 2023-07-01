USING: combinators.short-circuit.smart formatting kernel luhn
math math.parser qw sequences strings unicode ;
IN: rosetta-code.isin

CONSTANT: test-cases qw{
    US0378331005 US0373831005 U50378331005 US03378331005
    AU0000XVGZA3 AU0000VXGZA3 FR0000988040
}

: valid-length? ( str -- ? ) length 12 = ;

: valid-country-code? ( str -- ? ) first2 [ Letter? ] both? ;

: valid-security-code? ( str -- ? )
    [ 2 11 ] dip subseq [ alpha? ] all? ;

: valid-checksum-digit? ( str -- ? ) last digit? ;

: valid-format? ( str -- ? ) {
        [ valid-length?         ]
        [ valid-country-code?   ]
        [ valid-security-code?  ]
        [ valid-checksum-digit? ]
    } && ;

: base36>base10 ( str -- n )
    >upper [ dup LETTER? [ 55 - number>string ] [ 1string ] if ]
    { } map-as concat string>number ;

: isin? ( str -- ? )
    { [ valid-format? ] [ base36>base10 luhn? ] } && ;

: main ( -- )
    test-cases [
        dup isin? "" " not" ? "%s is%s valid\n" printf
    ] each ;

MAIN: main
